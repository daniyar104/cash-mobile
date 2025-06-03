import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/localization/locales.dart';
import '../../../db/database_factory.dart';


class ExpenseAnalyticsPage extends StatefulWidget {
  const ExpenseAnalyticsPage({super.key});

  @override
  State<ExpenseAnalyticsPage> createState() => _ExpenseAnalyticsPageState();
}

class _ExpenseAnalyticsPageState extends State<ExpenseAnalyticsPage> {
  final _dbHelper = getDatabaseHelper();

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  Map<String, double> categoryTotals = {};
  double totalExpense = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    final txs = await _dbHelper.getUserExpenses(userId);
    final filtered = txs.where((tx) {
      final txDate = DateTime.parse(tx.date);
      return txDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          txDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    Map<String, double> grouped = {};
    double sum = 0.0;

    for (var tx in filtered) {
      final category = tx.category ?? 'Прочее';
      grouped[category] = (grouped[category] ?? 0) + tx.amount;
      sum += tx.amount;
    }

    setState(() {
      categoryTotals = grouped;
      totalExpense = sum;
      _loading = false;
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
        _loading = true;
      });
      _loadExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final chartData = categoryTotals.entries
        .map((e) => _ChartData(e.key, e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return Scaffold(
      appBar: AppBar(title: Text(LocalData.statics.getString(context))),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(LocalData.expenses.getString(context), style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                Text(LocalData.income.getString(context), style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: SfCircularChart(
              series: <DoughnutSeries<_ChartData, String>>[
                DoughnutSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (d, _) => d.category,
                  yValueMapper: (d, _) => d.amount,
                  innerRadius: '70%',
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                )
              ],
              annotations: [
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${totalExpense.toStringAsFixed(0)} ₸',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: chartData.map((e) {
                final percent = ((e.amount / totalExpense) * 100).toStringAsFixed(1);
                return ListTile(
                  leading: const Icon(Icons.label_important, color: Colors.amber),
                  title: Text(e.category),
                  subtitle: Text('$percent %'),
                  trailing: Text('${e.amount.toStringAsFixed(0)} ₸',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
  final String category;
  final double amount;

  _ChartData(this.category, this.amount);
}
