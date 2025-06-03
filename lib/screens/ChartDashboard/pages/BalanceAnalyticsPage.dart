import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled1/localization/locales.dart';
import '../../../db/database_factory.dart';
import '../../../models/TransactionModel.dart';

class BalanceAnalyticsPage extends StatefulWidget {
  const BalanceAnalyticsPage({super.key});

  @override
  State<BalanceAnalyticsPage> createState() => _BalanceAnalyticsPageState();
}

class _BalanceAnalyticsPageState extends State<BalanceAnalyticsPage> {
  final _dbHelper = getDatabaseHelper();

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  double income = 0.0;
  double expense = 0.0;
  List<TransactionModel> filteredTransactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    final allTx = await _dbHelper.getUserTransactions(userId);
    final filtered = allTx.where((tx) {
      final date = DateTime.parse(tx.date);
      return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (var tx in filtered) {
      if (tx.type == 'income') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }

    setState(() {
      income = totalIncome;
      expense = totalExpense;
      filteredTransactions = filtered;
      loading = false;
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        loading = true;
      });
      _loadData();
    }
  }

  Map<String, double> _groupDailyBalance(List<TransactionModel> txs) {
    final Map<String, double> map = {};
    for (var tx in txs) {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.parse(tx.date));
      map[date] = (map[date] ?? 0) + (tx.type == 'income' ? tx.amount : -tx.amount);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dailyBalance = _groupDailyBalance(filteredTransactions);

    final chartData = dailyBalance.entries.map((e) {
      final day = DateFormat('dd.MM').format(DateTime.parse(e.key));
      return _ChartData(day, e.value);
    }).toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    final grouped = <String, List<TransactionModel>>{};
    for (var tx in filteredTransactions) {
      grouped.putIfAbsent(tx.date, () => []).add(tx);
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: Text("${LocalData.expenses.getString(context)}/${LocalData.income.getString(context)}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.wallet),
                const SizedBox(width: 8),
                const Spacer(),
                InkWell(
                  onTap: _selectDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${DateFormat('dd.MM').format(startDate)} - ${DateFormat('dd.MM').format(endDate)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+ ${(income - expense).toStringAsFixed(0)} ₸',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text('${LocalData.earned.getString(context)}: ${income.toStringAsFixed(0)} ₸'),
                    Text('${LocalData.spent.getString(context)}: ${expense.toStringAsFixed(0)} ₸'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              series: [
                ColumnSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.amount,
                  pointColorMapper: (d, _) => d.amount >= 0 ? Colors.green : Colors.red,
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              children: sortedDates.map((dateStr) {
                final items = grouped[dateStr]!;
                final date = DateFormat('dd MMMM', 'ru').format(DateTime.parse(dateStr));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...items.map((tx) => ListTile(
                      leading: const Icon(Icons.label),
                      // title: Text(tx.title),
                      title: Text(tx.category ?? ''),
                      // subtitle: Text(tx.category ?? ''),
                      trailing: Text(
                        '${tx.type == 'income' ? '+' : '-'}${tx.amount.toStringAsFixed(0)} ₸',
                        style: TextStyle(
                          color: tx.type == 'income' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String day;
  final double amount;

  _ChartData(this.day, this.amount);
}
