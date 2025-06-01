import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled1/localization/locales.dart';
import 'package:untitled1/screens/ChartDashboard/pages/BalanceAnalyticsPage.dart';
import 'package:untitled1/screens/ChartDashboard/pages/ExpenseAnalyticsPage.dart';
import 'package:untitled1/screens/ChartDashboard/pages/IncomeAnalyticsPage.dart';

import '../../db/database_factory.dart';

class ChartDashboardPage extends StatefulWidget {
  const ChartDashboardPage({super.key});

  @override
  State<ChartDashboardPage> createState() => _ChartDashboardPageState();
}

class _ChartDashboardPageState extends State<ChartDashboardPage> {
  final _dbHelper = getDatabaseHelper();

  double incomeTotal = 0.0;
  double expenseTotal = 0.0;
  double balance = 0.0;

  Map<String, double> expenseCategories = {};
  Map<String, double> incomeCategories = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final userId = (await SharedPreferences.getInstance()).getInt('userId') ?? 0;

    final income = await _dbHelper.getUserIncomeTotal(userId);
    final expense = await _dbHelper.getUserExpensesTotal(userId);
    final allTx = await _dbHelper.getTransactions(userId);

    final Map<String, double> exp = {};
    final Map<String, double> inc = {};

    for (var tx in allTx) {
      if (tx.type == 'expense') {
        exp[tx.category ?? 'Другое'] = (exp[tx.category ?? 'Другое'] ?? 0) + tx.amount;
      } else if (tx.type == 'income') {
        inc[tx.category ?? 'Прочее'] = (inc[tx.category ?? 'Прочее'] ?? 0) + tx.amount;
      }
    }

    setState(() {
      incomeTotal = income;
      expenseTotal = expense;
      balance = income - expense;
      expenseCategories = exp;
      incomeCategories = inc;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.statics.getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            ChartCardBalance(balance: balance),
            ChartCardIncomeExpense(income: incomeTotal, expense: expenseTotal),
            ExpenceChartCardDonut(
              title: 'Расходы',
              amount: '${expenseTotal.toStringAsFixed(0)} ₸',
              color: Colors.deepOrange,
              dataMap: expenseCategories,
            ),
            IncomeChartCardDonut(
              title: 'Доходы',
              amount: '${incomeTotal.toStringAsFixed(0)} ₸',
              color: Colors.lightBlue,
              dataMap: incomeCategories,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartCardBalance extends StatelessWidget {
  final double balance;

  const ChartCardBalance({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final history = [
      ChartData('Mon', balance + 200000),
      ChartData('Tue', balance + 100000),
      ChartData('Wed', balance),
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BalanceAnalyticsPage()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(isVisible: false),
                  primaryYAxis: NumericAxis(isVisible: false),
                  plotAreaBorderWidth: 0,
                  series: <CartesianSeries<ChartData, String>>[
                    LineSeries<ChartData, String>(
                      dataSource: history,
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.value,
                      color: Colors.green,
                      width: 3,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Доступные средства', style: TextStyle(fontWeight: FontWeight.w500)),
              Text('${balance.toStringAsFixed(0)} ₸',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartCardIncomeExpense extends StatelessWidget {
  final double income;
  final double expense;

  const ChartCardIncomeExpense({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final net = income - expense;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BalanceAnalyticsPage()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(isVisible: false),
                  primaryYAxis: NumericAxis(isVisible: false),
                  plotAreaBorderWidth: 0,
                  series: <CartesianSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                      dataSource: [
                        ChartData('Доходы', income),
                        ChartData('Расходы', expense),
                      ],
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.value,
                      pointColorMapper: (ChartData data, _) =>
                      data.category == 'Доходы' ? Colors.green : Colors.red,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Доходы/Расходы', style: TextStyle(fontWeight: FontWeight.w500)),
              Text('${net.toStringAsFixed(0)} ₸',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}


class ExpenceChartCardDonut extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final Map<String, double> dataMap;

  const ExpenceChartCardDonut({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    final data = dataMap.entries
        .map((e) => ChartData(e.key, e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExpenseAnalyticsPage()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SfCircularChart(
                  series: <DoughnutSeries<ChartData, String>>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: data,
                      xValueMapper: (ChartData d, _) => d.category,
                      yValueMapper: (ChartData d, _) => d.value,
                      innerRadius: '75%',
                      radius: '90%',
                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                    )
                  ],
                ),
              ),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}


class IncomeChartCardDonut extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final Map<String, double> dataMap;

  const IncomeChartCardDonut({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.dataMap,
  });

  @override
  Widget build(BuildContext context) {
    final data = dataMap.entries
        .map((e) => ChartData(e.key, e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IncomeAnalyticsPage()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SfCircularChart(
                  series: <DoughnutSeries<ChartData, String>>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: data,
                      xValueMapper: (ChartData d, _) => d.category,
                      yValueMapper: (ChartData d, _) => d.value,
                      innerRadius: '75%',
                      radius: '90%',
                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                    )
                  ],
                ),
              ),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final double value;
  ChartData(this.category, this.value);
}
