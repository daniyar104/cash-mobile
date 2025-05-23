import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

import '../models/ScheduledPayment.dart';
import '../models/UserModel.dart';
import '../models/TransactionModel.dart';
import 'app_database_helper.dart';

class SembastDatabaseHelper implements AppDatabaseHelper {
  static final SembastDatabaseHelper instance = SembastDatabaseHelper._internal();
  final StoreRef<int, Map<String, dynamic>> scheduledPaymentsStore = intMapStoreFactory.store('scheduled_payments');

  static Database? _db;

  factory SembastDatabaseHelper() {
    return instance;
  }

  SembastDatabaseHelper._internal();

  // Хранилища
  final StoreRef<int, Map<String, dynamic>> usersStore = intMapStoreFactory.store('users');
  final StoreRef<int, Map<String, dynamic>> transactionsStore = intMapStoreFactory.store('transactions');

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      return await databaseFactoryMemoryFs.openDatabase('app.db');
    } else {
      Directory dir = await getApplicationDocumentsDirectory();
      String dbPath = join(dir.path, 'app.db');
      return await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  // ========== User methods ==========
  @override
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await usersStore.add(db, user.toMap());
  }
  @override
  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final snapshots = await usersStore.find(db);
    return snapshots.map((e) => UserModel.fromMap({...e.value, 'id': e.key})).toList();
  }
  @override
  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final record = await usersStore.record(id).get(db);
    return record != null ? UserModel.fromMap({...record, 'id': id}) : null;
  }
  @override
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    await usersStore.record(user.id!).put(db, user.toMap());
    return user.id!;
  }

  @override
  Future<int> deleteUser(int id) async {
    final db = await database;
    await usersStore.record(id).delete(db);
    return id;
  }

  // ========== Transaction methods ==========
  @override
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;

    final int id = await transactionsStore.add(db, transaction.toMap());

    final userRecord = await usersStore.record(transaction.userId).get(db);
    if (userRecord != null) {
      double userAmount = userRecord['amount'] ?? 0.0;
      if (transaction.type == 'income') {
        userAmount += transaction.amount;
      } else {
        userAmount -= transaction.amount;
      }
      await usersStore.record(transaction.userId).update(db, {'amount': userAmount});
    }
    return id;
  }
  @override
  Future<List<TransactionModel>> getUserExpenses(int userId) async {
    final db = await database;
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('user_id', userId),
        Filter.equals('type', 'expense'),
      ]),
    );
    final records = await transactionsStore.find(db, finder: finder);
    return records.map((e) => TransactionModel.fromMap({...e.value, 'id': e.key})).toList();
  }

  Future<List<TransactionModel>> getTransactions(int userId) async {
    final db = await database;
    final finder = Finder(filter: Filter.equals('user_id', userId));
    final records = await transactionsStore.find(db, finder: finder);
    return records.map((e) => TransactionModel.fromMap({...e.value, 'id': e.key})).toList();
  }

  Future<List<TransactionModel>> getTransactionsOnlyExpanse(int userId) async {
    final db = await database;
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('user_id', userId),
        Filter.equals('type', 'expense'),
      ]),
    );
    final records = await transactionsStore.find(db, finder: finder);
    return records.map((e) => TransactionModel.fromMap({...e.value, 'id': e.key})).toList();
  }
  @override
  Future<List<TransactionModel>> getUserIncomes(int userId) async {
    final db = await database;
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('userId', userId),
        Filter.equals('type', 'income'),
      ]),
    );


    final recordSnapshots = await transactionsStore.find(db, finder: finder);

    return recordSnapshots.map((snapshot) {
      final transaction = TransactionModel.fromMap({...snapshot.value, 'id': snapshot.key});
      return transaction;
    }).toList();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final records = await transactionsStore.find(db);
    return records.map((e) => TransactionModel.fromMap({...e.value, 'id': e.key})).toList();
  }

  @override
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;

    await transactionsStore.record(transaction.id!).put(db, transaction.toMap());

    final userRecord = await usersStore.record(transaction.userId).get(db);
    if (userRecord != null) {
      double userAmount = userRecord['amount'] ?? 0.0;
      if (transaction.type == 'income') {
        userAmount += transaction.amount;
      } else {
        userAmount -= transaction.amount;
      }
      await usersStore.record(transaction.userId).update(db, {'amount': userAmount});
    }

    return transaction.id!;
  }

  @override
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    await transactionsStore.record(id).delete(db);
    return id;
  }

  @override
  Future<void> clearTransactions() async {
    final db = await database;
    await transactionsStore.delete(db);
  }

  @override
  Future<List<TransactionModel>> getUserTransactions(int userId) {
    return getTransactions(userId);
  }

  @override
  Future<void> init() async {
    await database;
  }

  @override
  Future<double> getUserExpensesTotal(int userId) async {
    final expenses = await getUserExpenses(userId);
    double total = expenses.fold(0.0, (sum, tx) => sum + tx.amount);
    return total;
  }
  @override
  Future<double> getUserIncomeTotal(int userId) async {
    final db = await database;
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('user_id', userId),
        Filter.equals('type', 'income'),
      ]),
    );

    final records = await transactionsStore.find(db, finder: finder);
    double total = records.fold(0.0, (sum, record) {
      final map = record.value;
      final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });

    return total;
  }

  @override
  Future<double> getTotalSpentOnFood(int userId) async {
    final db = await database;

    final finder = Finder(
      filter: Filter.and([
        Filter.equals('user_id', userId),
        Filter.equals('type', 'expense'),
        Filter.equals('category', 'food'),
      ]),
    );

    final records = await transactionsStore.find(db, finder: finder);

    double total = records.fold(0.0, (sum, record) {
      final map = record.value;
      final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });

    return total;
  }

  @override
  Future<double> getTotalSpentOnFoodForCurrentMonth(int userId) async {
    final db = await database;

    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    final finder = Finder(
      filter: Filter.and([
        Filter.equals('user_id', userId),
        Filter.equals('type', 'expense'),
        Filter.equals("category", "Food"),
        Filter.greaterThanOrEquals('date', DateTime(currentYear, currentMonth, 1).millisecondsSinceEpoch),
        Filter.lessThanOrEquals('date', DateTime(currentYear, currentMonth + 1, 0, 23, 59, 59).millisecondsSinceEpoch),
      ]),
    );

    final records = await transactionsStore.find(db, finder: finder);
    double total = records.fold(0.0, (sum, record) {
      final map = record.value;
      final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });

    return total;
  }

  @override
  Future<double> getTotalSpentOnShoppingForCurrentMonth(int userId) async {
    final db = await database;

    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    final finder = Finder(
      filter: Filter.and([
        Filter.equals('user_id', userId),
        Filter.equals('type', 'expense'),
        Filter.equals("category", "Shopping"),
        Filter.greaterThanOrEquals('date', DateTime(currentYear, currentMonth, 1).millisecondsSinceEpoch),
        Filter.lessThanOrEquals('date', DateTime(currentYear, currentMonth + 1, 0, 23, 59, 59).millisecondsSinceEpoch),
      ]),
    );

    final records = await transactionsStore.find(db, finder: finder);
    double total = records.fold(0.0, (sum, record) {
      final map = record.value;
      final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });

    return total;
  }
  @override
  Future<String> getUserNameById(int id) async {
    final db = await database;
    final record = await usersStore.record(id).get(db);
    return record != null ? record['username'] : '';
  }

  @override
  Future<void> deleteTransactionAndRestoreBalance(int transactionId, int userId) async {
    final db = await database;

    // Получаем транзакцию по id
    final transactionRecord = await transactionsStore.record(transactionId).get(db);

    if (transactionRecord == null) {
      // Если транзакция не найдена, просто выходим
      return;
    }

    // Извлекаем данные транзакции
    final transaction = TransactionModel.fromMap({...transactionRecord, 'id': transactionId});

    // Получаем текущие данные пользователя
    final userRecord = await usersStore.record(userId).get(db);
    if (userRecord == null) {
      // Если пользователь не найден, ничего не делаем
      return;
    }

    double userAmount = userRecord['amount'] ?? 0.0;

    // Восстанавливаем баланс пользователя, противоположно операции транзакции
    if (transaction.type == 'income') {
      userAmount -= transaction.amount; // Уменьшаем сумму, так как удаляем доход
    } else if (transaction.type == 'expense') {
      userAmount += transaction.amount; // Увеличиваем сумму, так как удаляем расход
    }

    // Обновляем баланс пользователя в базе
    await usersStore.record(userId).update(db, {'amount': userAmount});

    // Удаляем транзакцию из базы
    await transactionsStore.record(transactionId).delete(db);
  }

  // Вставка ScheduledPayment
  Future<int> insertScheduledPayment(ScheduledPayment payment) async {
    final db = await database;
    return await scheduledPaymentsStore.add(db, payment.toMap());
  }

// Получение всех ScheduledPayment для пользователя
  Future<List<ScheduledPayment>> getScheduledPayments(int userId) async {
    final db = await database;
    final finder = Finder(filter: Filter.equals('user_id', userId));
    final records = await scheduledPaymentsStore.find(db, finder: finder);
    return records.map((e) => ScheduledPayment.fromMap({...e.value, 'id': e.key})).toList();
  }

// Обновление ScheduledPayment
  Future<int> updateScheduledPayment(ScheduledPayment payment) async {
    final db = await database;
    await scheduledPaymentsStore.record(payment.id!).put(db, payment.toMap());
    return payment.id!;
  }

// Удаление ScheduledPayment по id
  Future<int> deleteScheduledPayment(int id) async {
    final db = await database;
    await scheduledPaymentsStore.record(id).delete(db);
    return id;
  }

}
