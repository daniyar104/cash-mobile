import 'package:flutter/material.dart';
import 'package:untitled1/widgets/AccountSummaryWidget.dart';
import 'package:untitled1/widgets/IncomeTransactionListWidget.dart';
import 'package:untitled1/widgets/RecentTransactionsWidget.dart';
import '../widgets/ExpenseTransactionsListWidget.dart';
import '../widgets/syncfusion/ColumnChartSample.dart';
import '../widgets/syncfusion/ExpensesChart.dart';

class TransactionsListPage extends StatefulWidget {
  final int userID;

  TransactionsListPage({required this.userID});

  @override
  State<TransactionsListPage> createState() => _TransactionsListPageState();
}

class _TransactionsListPageState extends State<TransactionsListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccountSummaryWidget(),
              SizedBox(height: 20),
              ExpensesChart(userId: widget.userID),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [

                    RecentTransactionsWidget(userID: widget.userID),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => ExpenseTransactionsListWidget(userID: widget.userID),
                    //           // builder: (context) => IncomeTransactionListWidget(userID: widget.userID),
                    //         ),
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       minimumSize: Size(double.infinity, 50),
                    //       backgroundColor: Theme.of(context).colorScheme.primary,
                    //     ),
                    //     child: Text(
                    //       'Show all',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         color: Theme.of(context).colorScheme.onPrimary,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}