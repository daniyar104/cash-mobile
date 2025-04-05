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
  late Future<List<TransactionModel>> _transactionsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactionsFuture = _loadTransactions();
  }
  Future<List<TransactionModel>> _loadTransactions() async {
    return DataBaseHelper.instance.getTransactions(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: _transactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Отображаем индикатор загрузки
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Отображаем ошибку
        } else if (snapshot.hasData) {
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.title),
                subtitle: Text(
                    'Amount: ${transaction.amount}, Date: ${transaction.date}, Category: ${transaction.category}'),
              );
            },
          );
        } else {
          return Center(child: Text('No transactions found.')); // Отображаем сообщение, если нет данных
        }
      },
    );
  }
}