import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/db/database_helper.dart';

class AccountSummaryWidget extends StatefulWidget{
  @override
  _AccountSummaryWidgetState createState() => _AccountSummaryWidgetState();
}

class _AccountSummaryWidgetState extends State<AccountSummaryWidget>{
  double userAmount = 0.0;
  int userId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserAmount();
  }
  Future<void> _loadUserAmount() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
    final users = await DataBaseHelper.instance.getUsers();
    final user = users.firstWhere((user) => user.id == userId);
    userAmount = user.amount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '\$${userAmount.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}