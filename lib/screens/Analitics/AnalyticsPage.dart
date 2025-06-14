import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../db/database_helper.dart';
import '../../localization/locales.dart';


class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  double incomeTotal = 0.0;
  double expenseTotal = 0.0;
  double balance = 0.0;
  double averageExpense = 0.0;
  double maxExpense = 0.0;
  Map<String, double> categoryExpenses = {};
  Map<String, double> monthlyExpenses = {};
  String currencySymbol = '₸';

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final currency = prefs.getString('currency') ?? 'KZT';
    currencySymbol = _getCurrencySymbol(currency);

    if (userId == null) return;


    final income = await DataBaseHelper.instance.getUserIncomeTotal(userId);
    final expense = await DataBaseHelper.instance.getUserExpensesTotal(userId);
    final transactions = await DataBaseHelper.instance.getUserTransactions(userId);
    final expenses = await DataBaseHelper.instance.getUserExpenses(userId);

    final categoryMap = <String, double>{};
    final monthlyMap = <String, double>{};
    double total = 0.0;
    double max = 0.0;

    for (var tx in expenses) {
      final category = tx.category ?? 'Прочее';
      categoryMap[category] = (categoryMap[category] ?? 0) + tx.amount;

      final month = tx.date.substring(0, 7); // "2025-05"
      monthlyMap[month] = (monthlyMap[month] ?? 0) + tx.amount;

      total += tx.amount;
      if (tx.amount > max) max = tx.amount;
    }

    setState(() {
      incomeTotal = income;
      expenseTotal = expense;
      balance = income - expense;
      averageExpense = expenses.isEmpty ? 0.0 : total / expenses.length;
      maxExpense = max;
      categoryExpenses = categoryMap;
      monthlyExpenses = monthlyMap;
    });
  }
  String _getCurrencySymbol(String code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'RUB':
        return '₽';
      case 'KZT':
      default:
        return '₸';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocalData.statics.getString(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildPieChart(),
            const SizedBox(height: 20),
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow(LocalData.income.getString(context), incomeTotal),
            _buildStatRow(LocalData.expenses.getString(context), expenseTotal),
            _buildStatRow(LocalData.balance.getString(context), balance),
            _buildStatRow(LocalData.averageExpense.getString(context), averageExpense),
            _buildStatRow(LocalData.maxExpense.getString(context), maxExpense),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text("${value.toStringAsFixed(2)} $currencySymbol",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final data = categoryExpenses.entries
        .map((e) => _ChartData(e.key, e.value))
        .toList();

    return SfCircularChart(
      title: ChartTitle(text: LocalData.categoryExpanses.getString(context)),
      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <PieSeries<_ChartData, String>>[
        PieSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum.label,
          yValueMapper: (datum, _) => datum.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }

  Widget _buildBarChart() {
    final data = monthlyExpenses.entries
        .map((e) => _ChartData(e.key, e.value))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return SfCartesianChart(
      title: ChartTitle(text: LocalData.monthlyExpanses.getString(context)),
      primaryXAxis: CategoryAxis(),
        series: <CartesianSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
            dataSource: data,
            xValueMapper: (datum, _) => datum.label,
            yValueMapper: (datum, _) => datum.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ]

    );
  }
}

class _ChartData {
  final String label;
  final double value;

  _ChartData(this.label, this.value);
}
