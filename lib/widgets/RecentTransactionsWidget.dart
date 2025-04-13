import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:untitled1/models/TransactionModel.dart';
import 'package:untitled1/widgets/AllTransactionPageWithTypes.dart';

import '../db/app_database_helper.dart';
import '../db/database_factory.dart';
import '../localization/locales.dart';
import 'ExpenseTransactionsListWidget.dart';

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
class RecentTransactionsWidget extends StatefulWidget {
  final int userID;

  const RecentTransactionsWidget({super.key, required this.userID});

  @override
  State<RecentTransactionsWidget> createState() => _RecentTransactionsWidgetState();
}

class _RecentTransactionsWidgetState extends State<RecentTransactionsWidget> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      // future: DataBaseHelper.instance.getTransactionsOnlyExpanse(widget.userID),
      future: _dbHelper.getUserExpenses(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Нет данных для отображения',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final allItems = snapshot.data ?? [];
        final items = (allItems.length > 3
            ? allItems.sublist(allItems.length - 3)
            : allItems).reversed.toList();

        return Column(
          children: [
            Text(
              "Transactions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Column(
              children: items.map((transaction) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Icon(
                              getCategoryIcon(transaction.category ?? ''),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocalData.getTranslatedCategory(context, transaction.category),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                transaction.date,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '-${transaction.amount}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllTransactionPageWithTypes(),
                      // builder: (context) => ExpenseTransactionsListWidget(userID: widget.userID),
                      // builder: (context) => IncomeTransactionListWidget(userID: widget.userID),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  LocalData.showAll.getString(context),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
