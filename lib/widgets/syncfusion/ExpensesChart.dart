import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled1/db/database_helper.dart';

import '../../db/sembast_database_helper.dart';

class ExpensesChart extends StatefulWidget {
  final int userId;

  const ExpensesChart({required this.userId});

  @override
  State<ExpensesChart> createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> {
  late Future<List<_DailyExpense>> futureGroupedExpenses;

  Future<List<_DailyExpense>> _fetchGroupedExpenses() async {
    // final expenses = await DataBaseHelper.instance.getTransactionsOnlyExpanse(widget.userId);
    final expenses = await SembastDatabaseHelper().getTransactionsOnlyExpanse(widget.userId);
    final Map<String, double> grouped = {};

    for (var tx in expenses) {
      final date = DateFormat('dd-MM-yyyy').parse(tx.date);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      grouped[dateStr] = (grouped[dateStr] ?? 0) + tx.amount;
    }

    final List<_DailyExpense> result = grouped.entries
        .map((e) => _DailyExpense(DateTime.parse(e.key), e.value))
        .toList();

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_DailyExpense>>(
      future: _fetchGroupedExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Ошибка: ${snapshot.error}"));
        } else if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.hasData == false || snapshot.data!.isEmpty)) {
          return Center(child: Text("Нет данных для отображения"));
        } else {
          final data = snapshot.data!;

          return SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              intervalType: DateTimeIntervalType.days,
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value} ₸',
            ),
            title: ChartTitle(text: 'Expenses by day'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              ColumnSeries<_DailyExpense, DateTime>(
                dataSource: data,
                xValueMapper: (d, _) => d.date,
                yValueMapper: (d, _) => d.total,
                name: 'Расходы',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          );
        }
      },
    );
  }
}

class _DailyExpense {
  final DateTime date;
  final double total;

  _DailyExpense(this.date, this.total);
}
