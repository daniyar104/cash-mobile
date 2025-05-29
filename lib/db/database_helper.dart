import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ScheduledPayment.dart';
import '../models/TransactionModel.dart';
import '../models/UserModel.dart';
import 'app_database_helper.dart';

class DataBaseHelper implements AppDatabaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();
  static Database? _database;

  DataBaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createDatabase(db);
        await _insertFakeData(db);
      },
    );
  }

  Future<void> _createDatabase(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT,
        amount REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        time TEXT,
        category TEXT,
        user_id INTEGER,
        type TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE scheduled_payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        category TEXT,
        user_id INTEGER,
        type TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
  }

  Future<void> _insertFakeData(Database db) async {
    int userId = await db.insert('users', {
      'username': 'demo_user',
      'email': 'demo@example.com',
      'password': '123456',
      'amount': 10000.0,
    });

    final now = DateTime.now();
    final List<String> expenseTitles = ['Магазин', 'Кафе', 'Проезд', 'Подписка', 'Транспорт', 'Кино', 'Аптека'];
    final List<String> incomeTitles = ['Зарплата', 'Фриланс', 'Подарок', 'Возврат налога'];

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final timeStr = DateFormat('HH:mm').format(date);

      if (i % 3 == 0) {
        await db.insert('transactions', {
          'title': incomeTitles[i % incomeTitles.length],
          'amount': 5000 + (i * 7 % 1000),
          'date': dateStr,
          'time': timeStr,
          'category': '💼',
          'user_id': userId,
          'type': 'income',
        });
      }

      await db.insert('transactions', {
        'title': expenseTitles[i % expenseTitles.length],
        'amount': 300 + (i * 11 % 500),
        'date': dateStr,
        'time': timeStr,
        'category': '🛒',
        'user_id': userId,
        'type': 'expense',
      });

      if (i % 2 == 0) {
        await db.insert('transactions', {
          'title': expenseTitles[(i + 1) % expenseTitles.length],
          'amount': 150 + (i * 9 % 300),
          'date': dateStr,
          'time': timeStr,
          'category': '🍔',
          'user_id': userId,
          'type': 'expense',
        });
      }
    }

    final List<Map<String, dynamic>> scheduled = [
      {'title': 'Интернет', 'amount': 3500.0, 'icon': Icons.wifi},
      {'title': 'Коммунальные', 'amount': 8000.0, 'icon': Icons.home},
      {'title': 'Мобильная связь', 'amount': 2000.0, 'icon': Icons.phone_android},
      {'title': 'Транспортная карта', 'amount': 4000.0, 'icon': Icons.directions_bus},
      {'title': 'Netflix', 'amount': 2990.0, 'icon': Icons.movie},
      {'title': 'Spotify', 'amount': 1590.0, 'icon': Icons.music_note},
      {'title': 'Страховка', 'amount': 12000.0, 'icon': Icons.shield},
    ];

    for (var item in scheduled) {
      await db.insert('scheduled_payments', {
        'title': item['title'],
        'amount': item['amount'],
        'date': DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 7))),
        'category': item['icon'].codePoint.toString(),
        'user_id': userId,
        'type': 'monthly',
      });
    }
  }

  // Методы для работы с UserModel
  @override
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  @override
  Future<String> getUserNameById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first['username'] as String;
    } else {
      return '';
    }
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }
  @override
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  @override
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Методы для работы с TransactionModel
  @override
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('transactions', transaction.toMap());
      final user = await txn.query('users', where: 'id = ?', whereArgs: [transaction.userId]);
      if (user.isNotEmpty) {
        final userAmount = user.first['amount'];
        double newAmount = userAmount != null ? userAmount as double : 0.0;
        if (transaction.type == 'income') {
          newAmount += transaction.amount;
        } else {
          newAmount -= transaction.amount;
        }
        await txn.update('users', {'amount': newAmount}, where: 'id = ?', whereArgs: [transaction.userId]);
      } else {
        print("Пользователь не найден при insertTransaction");
      }
    });
    return transaction.id ?? 0;
  }
  @override
  Future<List<TransactionModel>> getTransactions(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }
  @override
  Future<List<TransactionModel>> getTransactionsOnlyExpanse(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, 'expense'],
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }
  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }
  @override
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
      final user = await txn.query('users', where: 'id = ?', whereArgs: [transaction.userId]);
      if (user.isNotEmpty) {
        final userAmount = user.first['amount'];
        double newAmount = (userAmount is double) ? userAmount : 0.0;
        if (transaction.type == 'income') {
          newAmount += transaction.amount;
        } else {
          newAmount -= transaction.amount;
        }
        await txn.update('users', {'amount': newAmount}, where: 'id = ?', whereArgs: [transaction.userId]);
      } else {
        print("User not found while updating transaction");
      }
    });
    return transaction.id ?? 0;
  }
  @override
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> clearTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

  @override
  Future<List<TransactionModel>> getUserExpenses(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, 'expense'],
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }
  @override
  Future<double> getUserExpensesTotal(int userId) async {
    final expenses = await getUserExpenses(userId);
    double total = expenses.fold(0.0, (sum, tx) => sum + tx.amount);
    return total;
  }
  @override
  Future<double> getUserIncomeTotal(int userId) async {
    final incomes = await getUserIncomes(userId);
    double total = incomes.fold(0.0, (sum, tx) => sum + tx.amount);
    return total;
  }

  @override
  Future<List<TransactionModel>> getUserIncomes(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, 'income'],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

    @override
  Future<List<TransactionModel>> getUserTransactions(int userId) {
    return getTransactions(userId);
  }

  @override
  Future<double> getTotalSpentOnFood(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
    SELECT SUM(amount) as total 
    FROM transactions 
    WHERE user_id = ? AND type = 'expense' AND category = 'Food'
    ''',
      [userId],
    );

    final total = result.first['total'];
    return (total != null) ? (total as num).toDouble() : 0.0;
  }

  @override
  Future<double> getTotalSpentOnFoodForCurrentMonth(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'expense' AND category = 'Food' AND date BETWEEN ? AND ?
      ''',
      [userId, '2025-04-01', '2025-04-31'],
    );

    final total = result.first['total'];
    return total != null ? (total as num).toDouble() : 0.0;
  }

  @override
  Future<double> getTotalSpentOnShoppingForCurrentMonth(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE user_id = ? AND type = 'expense' AND category = 'Shopping' AND date BETWEEN ? AND ?
      ''',
      [userId, '2025-04-01', '2025-04-31'],
    );

    final total = result.first['total'];
    return total != null ? (total as num).toDouble() : 0.0;
  }


  @override
  Future<void> deleteTransactionAndRestoreBalance(int transactionId, int userId) async {
    final db = await database;

    final result = await db.query(
      'transactions',
      columns: ['amount'],
      where: 'id = ?',
      whereArgs: [transactionId],
    );

    if (result.isNotEmpty) {
      final amountToRestore = result.first['amount'] as double;

      final balanceResult = await db.query(
        'users',
        columns: ['amount'],
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (balanceResult.isNotEmpty) {
        double currentBalance = balanceResult.first['amount'] as double;

        double newBalance = currentBalance + amountToRestore;

        await db.update(
          'users',
          {'amount': newBalance},
          where: 'id = ?',
          whereArgs: [userId],
        );

        await db.delete(
          'transactions',
          where: 'id = ?',
          whereArgs: [transactionId],
        );
      }
    }
  }


  @override
  Future<void> init() async {
    await database;
    await _insertFakeData(await database);

  }



  // Методы для работы с ScheduledPayment
  @override
  Future<int> insertScheduledPayment(ScheduledPayment payment) async {
    final db = await database;
    return await db.insert('scheduled_payments', payment.toMap());
  }

  @override
  Future<List<ScheduledPayment>> getScheduledPayments(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scheduled_payments',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => ScheduledPayment.fromMap(maps[i]));
  }

  @override
  Future<int> updateScheduledPayment(ScheduledPayment payment) async {
    final db = await database;
    return await db.update(
      'scheduled_payments',
      payment.toMap(),
      where: 'id = ?',
      whereArgs: [payment.id],
    );
  }

  @override
  Future<int> deleteScheduledPayment(int id) async {
    final db = await database;
    return await db.delete(
      'scheduled_payments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
