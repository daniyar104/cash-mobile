import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/widgets/ExpenseTransactionsListWidget.dart';
import 'package:untitled1/widgets/allTransaction/AllTransactionListPage.dart';

import 'IncomeTransactionListWidget.dart';

class AllTransactionPageWithTypes extends StatefulWidget {
  const AllTransactionPageWithTypes({super.key});

  @override
  State<AllTransactionPageWithTypes> createState() => _AllTransactionPageWithTypesState();
}

class _AllTransactionPageWithTypesState extends State<AllTransactionPageWithTypes> {
  int userID = 0;
  final List<String> filters = ["All", "Expense", "Income", "Transfer"];
  String selectedFilter = "All";
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt('userId') ?? 0;
    });
  }
  Widget _getSelectedWidget() {
    switch (selectedFilter) {
      case "Expense":
        return ExpenseTransactionsListWidget(userID: userID,);
      case "Income":
        return IncomeTransactionListWidget(userID: userID);
      default:
        return AllTransactionListPage(userID: userID);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Transactions'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 50),
            height: 40,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                String filter = filters[index];
                bool isSelected = filter == selectedFilter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(child: _getSelectedWidget()),
        ],
      ),
    );
  }
}
