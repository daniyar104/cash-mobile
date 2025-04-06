import 'package:flutter/material.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';
import 'package:untitled1/widgets/RecentTransactionsWidget.dart';

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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.grey[200],
              ),
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              height: 350,
              child: Column(
                children: [
                  Text("Transactions",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  RecentTransactionsWidget(userID: widget.userID),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionsListWidget(userID: widget.userID),
                          ),
                        );
                      },
                      child: Text('Show all',
                        style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            ),

          ],
        ),
      ),
    );
  }
}