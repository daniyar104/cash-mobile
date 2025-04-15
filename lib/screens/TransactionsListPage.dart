import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';
import 'package:untitled1/widgets/RecentTransactionsWidget.dart';
import 'package:untitled1/widgets/totalCategory/TotalExpenseFood.dart';
import '../db/app_database_helper.dart';
import '../db/database_factory.dart';
import '../localization/locales.dart';
import '../widgets/syncfusion/ExpensesChart.dart';
import '../widgets/totalCategory/TotalExpenseShoping.dart';

class TransactionsListPage extends StatefulWidget {
  final int userID;

  const TransactionsListPage({required this.userID, super.key});

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dbHelper.getUserById(widget.userID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SafeArea(
              child: "${snapshot.data?.username}" == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${LocalData.welcome.getString(context)} ${"${snapshot.data?.username}!"}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 50,
                            color: Colors.grey[200],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    AccountSummaryWidget(),
                    SizedBox(height: 20),
                    ExpensesChart(userId: widget.userID),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TotalExpenseFood(userId: widget.userID),
                          TotalExpenseShopping(userId: widget.userID),
                          RecentTransactionsWidget(userID: widget.userID),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}