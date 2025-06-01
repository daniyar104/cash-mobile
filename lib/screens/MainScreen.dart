import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/localization/locales.dart';
import 'package:untitled1/screens/ExpenseInputScreen.dart';
import 'package:untitled1/screens/HomeScreen/HomePage.dart';
import 'package:untitled1/screens/Plannings/page/ScheduledPaymentsPage.dart';
import 'package:untitled1/screens/accountPage/MainAccountPage.dart';
import 'Analitics/AnalyticsPage.dart';
import 'ChartDashboard/ChartDashboardPage.dart';
import 'TransactionsListPage.dart';
import 'futureMainAccount/AccountPage.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  int _currentIndex = 0;
  late List<Widget> _pages;
  late int _userId = 0;
  Color _accentColor = Colors.blue;
  @override
  void initState() {
    super.initState();
    _pages = [
      TransactionsListPage(userID: _userId),
      // StatisticsPage(),
      ChartDashboardPage(),
      ScheduledPaymentsPage(userId: _userId),
      AccountPage(),
    ];
    _loadUserId();
    _loadAccentColor();
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
  Future<void> _loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('theme_color') ?? Colors.blue.value;
    setState(() {
      _accentColor = Color(colorValue);
    });
  }
  void _showAddTransactionForm() {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => ExpenseInputScreen(userId: _userId,)
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (_pages == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_filled,
                color: _currentIndex == 0 ? _accentColor : Colors.grey,
                size: _currentIndex == 0 ? 32 : 24,
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: Icon(
                Icons.analytics_outlined,
                color: _currentIndex == 1 ? _accentColor : Colors.grey,
                size: _currentIndex == 1 ? 32 : 24,
              ),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            SizedBox(width: 48),
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: _currentIndex == 2 ? _accentColor : Colors.grey,
                size: _currentIndex == 2 ? 32 : 24,
              ),
              onPressed: () => setState(() => _currentIndex = 2),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 3 ? _accentColor : Colors.grey,
                size: _currentIndex == 3 ? 32 : 24,
              ),
              onPressed: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionForm,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}


