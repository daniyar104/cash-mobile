import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  final String day;
  final double sales;

  SalesData(this.day, this.sales);
}

class ColumnChartSample extends StatelessWidget {
  final List<SalesData> data = [
    SalesData('Пн', 5),
    SalesData('Вт', 7),
    SalesData('Ср', 3),
    SalesData('Чт', 8),
    SalesData('Пт', 6),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Продажи по дням'),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(minimum: 0, maximum: 10, interval: 1),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        ColumnSeries<SalesData, String>(
          dataSource: data,
          xValueMapper: (SalesData sales, _) => sales.day,
          yValueMapper: (SalesData sales, _) => sales.sales,
          name: 'Продажи',
          color: Theme.of(context).colorScheme.primary,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        )
      ],
    );
  }
}