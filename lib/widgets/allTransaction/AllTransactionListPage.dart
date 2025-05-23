import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../db/app_database_helper.dart';
import '../../db/database_factory.dart';
import '../../db/database_helper.dart';
import '../../localization/locales.dart';
import '../../models/TransactionModel.dart';
import '../../utils/category_icon.dart';
import '../EditTransactionScreen.dart';


class AllTransactionListPage extends StatefulWidget {
  final int userID;
  const AllTransactionListPage({super.key, required this.userID});

  @override
  State<AllTransactionListPage> createState() => _AllTransactionListPageState();
}

class _AllTransactionListPageState extends State<AllTransactionListPage> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: _dbHelper.getTransactions(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data ?? [];

        final Map<String, List<TransactionModel>> grouped = {};
        for (var tx in transactions) {
          final formattedDate = _formatDate(tx.date ?? '');
          if (!grouped.containsKey(formattedDate)) {
            grouped[formattedDate] = [];
          }
          grouped[formattedDate]!.add(tx);
        }

        final sortedDates = grouped.keys.toList()
          ..sort((a, b) => _compareDates(b, a));

        return ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final items = grouped[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    return Dismissible(
      key: Key(tx.id.toString()),
      background: Container(
        color: Theme.of(context).colorScheme.secondary,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Theme.of(context).colorScheme.tertiary,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right to delete
          final confirm = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Delete Transaction'),
              content: Text('Are you sure you want to delete this transaction?'),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete')),
              ],
            ),
          );

          if (confirm == true) {
            await DataBaseHelper.instance.deleteTransactionAndRestoreBalance(tx.id!, widget.userID);
            setState(() {});
          }

          return confirm;
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTransactionScreen(transaction: tx),
            ),
          );
          return false;
        }
      },
      child: Container(
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
                      LocalData.getTranslatedCategory(context, tx.category),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      _formatDate(tx.date) ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${tx.amount}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(tx.time),
              ],
            )
          ],
        ),
      ),
    );
  }



  String _formatDate(String rawDate) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(rawDate);
      return DateFormat('d MMM').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }




  int _compareDates(String a, String b) {
    final months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };

    int parse(String dateStr) {
      final parts = dateStr.split(' ');
      if (parts.length != 2) return 0;
      final day = int.tryParse(parts[0]) ?? 0;
      final month = months[parts[1]] ?? 0;
      return DateTime(2025, month, day).millisecondsSinceEpoch;
    }

    return parse(a).compareTo(parse(b));
  }
}
