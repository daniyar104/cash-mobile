import 'package:flutter/material.dart';
import 'package:untitled1/models/TransactionModel.dart';

import '../db/database_helper.dart';
IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Icons.fastfood;
    case 'transport':
      return Icons.directions_bus;
    case 'shopping':
      return Icons.shopping_cart;
    case 'entertainment':
      return Icons.movie;
    case 'health':
      return Icons.health_and_safety;
    case "taxi":
      return Icons.local_taxi;
    default:
      return Icons.category;
  }
}
class TransactionsListWidget extends StatefulWidget{
  @override
  final int userID;

  TransactionsListWidget({required this.userID});
  State<TransactionsListWidget> createState() => _TransactionsListWidgetState();
}
class _TransactionsListWidgetState extends State<TransactionsListWidget>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: DataBaseHelper.instance.getTransactionsOnlyExpanse(widget.userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
      
          final items = snapshot.data ?? [];
          return Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              // shrinkWrap: true,
              // reverse: true,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                ),
                                child: Icon(
                                  getCategoryIcon('${items[index].category}'),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${items[index].category}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
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
                            ],
                          ),
                          Column(
                            children: [
                              Text('-${items[index].amount}',
                                style: TextStyle(
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
            ),
          );
        },
      ),

    );
  }
}