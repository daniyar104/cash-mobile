import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/app_database_helper.dart';
import '../db/database_factory.dart';

class TotalTransactionBalans extends StatefulWidget {
  const TotalTransactionBalans({super.key});

  @override
  State<TotalTransactionBalans> createState() => _TotalTransactionBalansState();
}

class _TotalTransactionBalansState extends State<TotalTransactionBalans> {
  double totalExpenses = 0.0;
  double totalIncomes = 0.0;
  int userId = 0;
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  initState() {
    super.initState();
    _loadTotalExpenses();
  }
  Future<void> _loadTotalExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;

    totalExpenses = await _dbHelper.getUserExpensesTotal(userId);
    totalIncomes = await _dbHelper.getUserIncomeTotal(userId);

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.trending_down, color: Colors.redAccent),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Expense",),
            Text(
              '₸ ${totalExpenses.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
          ],
        ),
        SizedBox(height: 10),
        Icon(Icons.trending_up, color: Colors.greenAccent),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Income",),
            Text(
              '₸ ${totalIncomes.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18, color: Colors.greenAccent),
            ),
          ],
        ),
      ],
    );
  }
}
