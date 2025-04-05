import 'package:flutter/material.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';

import '../widgets/TransactionsListWidget.dart';

class TransactionsListPage extends StatelessWidget {
  final int userID;

  TransactionsListPage({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: Column(
        children: [
          AccountSummaryWidget(),
          Expanded(
            child: TransactionsListWidget(userID: userID),
          ),
        ],
      ),
    );
  }
}