import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';

import '../models/UserModel.dart';
import '../models/TransactionModel.dart';
import 'app_database_helper.dart';

class SembastDatabaseHelper implements AppDatabaseHelper {
  static final SembastDatabaseHelper instance = SembastDatabaseHelper._internal();

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
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await usersStore.add(db, user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final snapshots = await usersStore.find(db);
    return snapshots.map((e) => UserModel.fromMap({...e.value, 'id': e.key})).toList();
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final record = await usersStore.record(id).get(db);
    return record != null ? UserModel.fromMap({...record, 'id': id}) : null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    await usersStore.record(user.id!).put(db, user.toMap());
    return user.id!;
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    await usersStore.record(id).delete(db);
    return id;
  }

  // ========== Transaction methods ==========
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

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final records = await transactionsStore.find(db);
    return records.map((e) => TransactionModel.fromMap({...e.value, 'id': e.key})).toList();
  }

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
    return getTransactions(userId); // просто прокси
  }

  @override
  Future<void> init() async {
    await database;
  }
}
