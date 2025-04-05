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
      future: DataBaseHelper.instance.getTransactions(widget.userID),
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
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer
                  ),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('${items[index].category}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('${items[index].date}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('${items[index].amount}',
                            style: TextStyle(
                              color: items[index].type == 'income' ? Colors.green : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}