import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/TransactionModel.dart';
import '../models/UserModel.dart';

class DataBaseHelper {
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
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
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
        category TEXT,
        user_id INTEGER,
        type TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
  }

  // Методы для работы с UserModel
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<UserModel>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }
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
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Методы для работы с TransactionModel
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('transactions', transaction.toMap());
      final user = await txn.query('users', where: 'id = ?', whereArgs: [transaction.userId]);
      if (user.isNotEmpty) { // Проверка на пустоту
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

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
      final user = await txn.query('users', where: 'id = ?', whereArgs: [transaction.userId]);
      if (user.isNotEmpty) { // Проверка на пустоту
        final userAmount = user.first['amount'];
        double newAmount = userAmount != null ? userAmount as double : 0.0;
        if (transaction.type == 'income') {
          newAmount += transaction.amount;
        } else {
          newAmount -= transaction.amount;
        }
        await txn.update('users', {'amount': newAmount}, where: 'id = ?', whereArgs: [transaction.userId]);
      } else {
        print("Пользователь не найден при updateTransaction");
      }
    });
    return transaction.id ?? 0;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}