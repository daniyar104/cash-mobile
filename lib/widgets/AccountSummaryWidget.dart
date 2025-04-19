import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/db/app_database_helper.dart';
import 'package:untitled1/db/database_factory.dart';

import '../localization/locales.dart';
import 'TotalTransactionBalans.dart';

class AccountSummaryWidget extends StatefulWidget{
  @override
  _AccountSummaryWidgetState createState() => _AccountSummaryWidgetState();
}

class _AccountSummaryWidgetState extends State<AccountSummaryWidget>{
  double userAmount = 0.0;
  int userId = 0;

  final AppDatabaseHelper _dbHelper = getDatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserAmount();
  }
  Future<void> _loadUserAmount() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
    final users = await _dbHelper.getUsers();

    final user = users.firstWhere((user) => user.id == userId);
    userAmount = user.amount;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(LocalData.summary.getString(context),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '₸ ${userAmount.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TotalTransactionBalans(),
            ],
          ),
        ),
      ),
    );
  }

}