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

class TransactionsListWidget extends StatefulWidget {
  final int userID;

  TransactionsListWidget({required this.userID});

  @override
  State<TransactionsListWidget> createState() => _TransactionsListWidgetState();
}

class _TransactionsListWidgetState extends State<TransactionsListWidget> {
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

          final transactions = snapshot.data ?? [];

          // Группировка транзакций по дате
          final Map<String, List<TransactionModel>> groupedTransactions = {};

          for (var tx in transactions) {
            final formattedDate = _formatDate(tx.date);
            if (!groupedTransactions.containsKey(formattedDate)) {
              groupedTransactions[formattedDate] = [];
            }
            groupedTransactions[formattedDate]!.add(tx);
          }

          final sortedKeys = groupedTransactions.keys.toList()
            ..sort((a, b) => _compareDates(b, a)); // Новые даты сверху

          return ListView.builder(
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final date = sortedKeys[index];
              final items = groupedTransactions[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...items.map((tx) => _buildTransactionItem(tx)).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  getCategoryIcon(tx.category!),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.category!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    tx.date,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '-${tx.amount}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Форматирует дату вида '2025-04-06' в '6 Апр'
  String _formatDate(String rawDate) {
    try {
      final parts = rawDate.split('-'); // ['06', '04', '2025']
      if (parts.length != 3) return 'Неизвестно';

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final months = [
        '', 'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
        'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'
      ];

      return '$day ${months[month]}';
    } catch (e) {
      return 'Неизвестно';
    }
  }

  int _compareDates(String a, String b) {
    final months = {
      'Янв': 1, 'Фев': 2, 'Мар': 3, 'Апр': 4, 'Май': 5, 'Июн': 6,
      'Июл': 7, 'Авг': 8, 'Сен': 9, 'Окт': 10, 'Ноя': 11, 'Дек': 12,
    };

    int parse(String dateStr) {
      final parts = dateStr.split(' ');
      return DateTime(2025, months[parts[1]]!, int.parse(parts[0])).millisecondsSinceEpoch;
    }

    return parse(a).compareTo(parse(b));
  }
}
