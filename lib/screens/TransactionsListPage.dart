import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/screens/HomeScreen/HomePage.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';
import 'package:untitled1/widgets/RecentTransactionsWidget.dart';
import 'package:untitled1/widgets/welcomeWidget/WelcomeWidget.dart';
import '../db/app_database_helper.dart';
import '../db/database_factory.dart';
import '../widgets/syncfusion/ExpensesChart.dart';
import '../widgets/totalCategory/TotalExpenseFood.dart';
import '../widgets/totalCategory/TotalExpenseShoping.dart';
import 'HomeScreen/SimpleTransactionListPage.dart';

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
  late int userId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAvatar();
    _loadUserId();
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
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _dbHelper.getUserById(widget.userID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            return SafeArea(
              child: snapshot.data?.username == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Row(
                      children: [
                        WelcomeWidget(),
                        const SizedBox(width: 8),
                        Text(
                          "${snapshot.data?.username}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: _avatarImage != null
                              ? FileImage(_avatarImage!)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AccountSummaryWidget(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SimpleTransactionListPage(userID: widget.userID),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}