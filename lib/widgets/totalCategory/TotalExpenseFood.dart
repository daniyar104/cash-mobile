import 'package:flutter/material.dart';

import '../../db/app_database_helper.dart';
import '../../db/database_factory.dart';

class TotalExpenseFood extends StatefulWidget {
  final int userId;
  const TotalExpenseFood({super.key, required this.userId});

  @override
  State<TotalExpenseFood> createState() => _TotalExpenseFoodState();
}

class _TotalExpenseFoodState extends State<TotalExpenseFood> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();

  Future<double> _getFoodExpense() async {
    return await _dbHelper.getTotalSpentOnFood(widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _getFoodExpense(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Ошибка: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == 0.0) {
          return Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }else {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.fastfood, color: Theme.of(context).colorScheme.onPrimary),
                SizedBox(width: 10),
                Text(
                  "Food",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Spacer(),
                Text(
                  "${snapshot.data!.toStringAsFixed(0)} ₸",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            )
          );
        }
      },
    );
  }
}
