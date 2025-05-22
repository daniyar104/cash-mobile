import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';
import 'package:untitled1/widgets/RecentTransactionsWidget.dart';
import 'package:untitled1/widgets/welcomeWidget/WelcomeWidget.dart';
import '../db/app_database_helper.dart';
import '../db/database_factory.dart';
import '../widgets/syncfusion/ExpensesChart.dart';
import '../widgets/totalCategory/TotalExpenseFood.dart';
import '../widgets/totalCategory/TotalExpenseShoping.dart';

class TransactionsListPage extends StatefulWidget {
  final int userID;

  const TransactionsListPage({required this.userID, super.key});

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  File? _avatarImage;
  String? _avatarPath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarPath = prefs.getString('avatar_path');
      if (_avatarPath != null) {
        _avatarImage = File(_avatarPath!);
      }
    });
  }

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
                        Row(
                          children: [
                            WelcomeWidget(),
                            Text("${snapshot.data?.username}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: _avatarImage != null
                              ? FileImage(_avatarImage!)
                              : null,
                        ),
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
                          // TotalExpenseFood(userId: widget.userID),
                          // TotalExpenseShopping(userId: widget.userID),
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