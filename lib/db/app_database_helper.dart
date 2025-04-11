// lib/db/app_database_helper.dart

import 'package:flutter/foundation.dart';
import 'package:untitled1/db/sembast_database_helper.dart';

import '../models/UserModel.dart';
import '../models/TransactionModel.dart';

abstract class AppDatabaseHelper {
  // User methods
  Future<List<UserModel>> getUsers();
  Future<UserModel?> getUserById(int id);
  Future<int> insertUser(UserModel user);
  Future<int> updateUser(UserModel user);
  Future<int> deleteUser(int id);

  // Transaction methods
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getUserTransactions(int userId);
  Future<int> insertTransaction(TransactionModel transaction);
  Future<int> updateTransaction(TransactionModel transaction);
  Future<int> deleteTransaction(int id);
  Future<void> clearTransactions();
  Future<List<TransactionModel>> getUserExpenses(int userId);
  Future<List<TransactionModel>> getUserIncomes(int userId);
  Future<void> init();
  Future<double> getUserExpensesTotal(int userId);
  Future<double> getUserIncomeTotal(int userId);

  Future<double> getTotalSpentOnFood(int userId);
  Future<double> getTotalSpentOnFoodForCurrentMonth(int userId);
}

