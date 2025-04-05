import 'package:flutter/material.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';

import '../models/TransactionModel.dart';
import '../widgets/TransactionsListWidget.dart';

class TransactionsListPage extends StatefulWidget {
  final int userID;

  TransactionsListPage({required this.userID});

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            AccountSummaryWidget(),
            Expanded(
              child: TransactionsListWidget(userID: widget.userID),
            ),
          ],
        ),
      ),
    );
  }
}