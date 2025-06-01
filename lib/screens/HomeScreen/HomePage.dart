import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../db/app_database_helper.dart';
import '../../db/database_factory.dart';
import '../../models/TransactionModel.dart';

class HomePage extends StatefulWidget {
  final int userID;
  const HomePage({super.key, required this.userID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];
  String _searchQuery = '';
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _loadTransactions() async {
    final transactions = await _dbHelper.getTransactions(widget.userID);
    if (_isMounted && mounted) {
      setState(() {
        _allTransactions = transactions;
        _filteredTransactions = transactions;
      });
    }
  }

  void _filterTransactions(String query) {
    if (!_isMounted || !mounted) return;
    setState(() {
      _searchQuery = query;
      _filteredTransactions = _allTransactions
          .where((tx) => tx.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Map<String, List<TransactionModel>> _groupByDate(List<TransactionModel> transactions) {
    Map<String, List<TransactionModel>> grouped = {};
    for (var tx in transactions) {
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.parse(tx.date));
      grouped.putIfAbsent(dateStr, () => []).add(tx);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(_filteredTransactions);
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: _filterTransactions,
                decoration: InputDecoration(
                  hintText: 'Поиск транзакции...',
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
            SizedBox(height: 16),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  final date = sortedDates[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(DateFormat('dd MMM', 'ru').format(DateTime.parse(date))),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredTransactions.isEmpty
                  ? const Center(child: Text('Нет транзакций'))
                  : ListView.builder(
                itemCount: sortedDates.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final date = sortedDates[index];
                  final items = grouped[date]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: Text(
                              DateFormat('dd MMMM yyyy', 'ru').format(DateTime.parse(date)),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...items.map(
                                (tx) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.type == 'income' ? Colors.green : Colors.red,
                                child: Text(
                                  tx.amount.toInt().toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(tx.title),
                              subtitle: Text('${tx.category} — ${tx.time}'),
                              trailing: Text(
                                tx.type == 'income' ? '+${tx.amount}' : '-${tx.amount}',
                                style: TextStyle(
                                  color: tx.type == 'income' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
