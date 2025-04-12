import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/localization/locales.dart';

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
  @override
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red[200],
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.trending_down, color: Colors.red),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocalData.expenses.getString(context)),
            Text(
              '₸ ${totalExpenses.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green[200],
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.trending_up, color: Colors.green),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocalData.income.getString(context)),
            Text(
              '₸ ${totalIncomes.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
