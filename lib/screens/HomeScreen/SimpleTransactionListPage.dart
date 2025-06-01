import 'package:flutter/material.dart';
import '../../db/app_database_helper.dart';
import '../../db/database_factory.dart';
import '../../models/TransactionModel.dart';

class SimpleTransactionListPage extends StatefulWidget {
  final int userID;

  const SimpleTransactionListPage({super.key, required this.userID});

  @override
  State<SimpleTransactionListPage> createState() => _SimpleTransactionListPageState();
}

class _SimpleTransactionListPageState extends State<SimpleTransactionListPage> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  List<TransactionModel> _transactions = [];
  List<TransactionModel> _filteredTransactions = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await _dbHelper.getTransactions(widget.userID);
    transactions.sort((a, b) => b.id!.compareTo(a.id!));
    setState(() {
      _transactions = transactions;
      _filteredTransactions = transactions;
    });
  }

  void _filterTransactions(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTransactions = _transactions
          .where((tx) =>
      (tx.title.toLowerCase().contains(query.toLowerCase()) ||
          tx.category?.toLowerCase().contains(query.toLowerCase()) == true))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: _filterTransactions,
            decoration: InputDecoration(
              hintText: 'Поиск по названию или категории...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredTransactions.isEmpty
              ? const Center(child: Text('Нет транзакций'))
              : ListView.builder(
            itemCount: _filteredTransactions.length,
            itemBuilder: (context, index) {
              final tx = _filteredTransactions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tx.type == 'income' ? Colors.green : Colors.red,
                      child: Icon(
                        tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      tx.category ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${tx.date} — ${tx.time}')
                      ],
                    ),
                    trailing: Text(
                      tx.type == 'income' ? '+${tx.amount}' : '-${tx.amount}',
                      style: TextStyle(
                        color: tx.type == 'income' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
