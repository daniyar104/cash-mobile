import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/TransactionModel.dart';

import '../db/database_helper.dart';

class TransactionsListWidget extends StatefulWidget{
  @override
  final int userID;

  TransactionsListWidget({required this.userID});
  State<TransactionsListWidget> createState() => _TransactionsListWidgetState();
}
class _TransactionsListWidgetState extends State<TransactionsListWidget>{


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: DataBaseHelper.instance.getTransactions(widget.userID), // Now returning List<TransactionModel>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final items = snapshot.data ?? [];
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index].title),  // Using model properties directly
              subtitle: Text('Amount: ${items[index].amount}'),
            );
          },
        );
      },
    );
  }
}