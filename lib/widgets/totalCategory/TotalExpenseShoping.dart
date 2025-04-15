import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../db/app_database_helper.dart';
import '../../db/database_factory.dart';
import '../../localization/locales.dart';

class TotalExpenseShopping extends StatefulWidget {
  final int userId;
  const TotalExpenseShopping({super.key, required this.userId});

  @override
  State<TotalExpenseShopping> createState() => _TotalExpenseShoppingState();
}

class _TotalExpenseShoppingState extends State<TotalExpenseShopping> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();

  Future<double> _getFoodExpense() async {
    return await _dbHelper.getTotalSpentOnShoppingForCurrentMonth(widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _getFoodExpense(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == 0.0) {
          return Center(
            child: Text(
              'No data to display',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.onPrimary),
                SizedBox(width: 10),
                Text(
                  LocalData.shopping.getString(context),
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
            ),
          );
        }
      },
    );
  }
}
