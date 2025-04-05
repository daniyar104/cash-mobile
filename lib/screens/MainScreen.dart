import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/screens/accountPage/MainAcountPage.dart';

import '../widgets/AddTransactionForm.dart';
import 'TransactionsListPage.dart';

class MainScreen extends StatefulWidget{
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  int _currentIndex = 0;
  late List<Widget> _pages;
  late int _userId = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      TransactionsListPage(userID: _userId),
      MainAcountPage(),

    ];
    _loadUserId();
  }
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        _userId = userId;
        _pages[0] = TransactionsListPage(userID: _userId);
      });
    } else {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  void _showAddTransactionForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddTransactionForm(userId: _userId);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionForm,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
