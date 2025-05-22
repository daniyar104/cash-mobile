import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';

class ExpensesAnalysisPage extends StatefulWidget {
  const ExpensesAnalysisPage({super.key});

  @override
  State<ExpensesAnalysisPage> createState() => _ExpensesAnalysisPageState();
}

class _ExpensesAnalysisPageState extends State<ExpensesAnalysisPage> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Analytics',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
