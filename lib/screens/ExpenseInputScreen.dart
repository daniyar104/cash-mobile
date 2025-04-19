import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/db/database_factory.dart';
import 'package:untitled1/screens/TranscationInput/top_bar_switcher.dart';
import '../localization/locales.dart';
import '../models/TransactionModel.dart';
import 'TranscationInput/amount_display.dart';
import 'TranscationInput/date_time_category_row.dart';
import 'TranscationInput/keypad.dart';

class ExpenseInputScreen extends StatefulWidget {
  final int userId;
  const ExpenseInputScreen({super.key, required this.userId});

  @override
  State<ExpenseInputScreen> createState() => _ExpenseInputScreenState();
}

class _ExpenseInputScreenState extends State<ExpenseInputScreen> {
  String amount = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedCategory = 'Food';
  int selectedTypeIndex = 0;
  final List<String> categories = ['Food', 'Transportation', 'Entertainment', 'Shopping', 'Other'];

  final _dbHelper = getDatabaseHelper();
  void _deleteLast() {
    setState(() {
      if (amount.isNotEmpty) {
        amount = amount.substring(0, amount.length - 1);
      }
    });
  }
  void _addDigit(String digit) {
    setState(() {
      if (digit == '.') {
        if (!amount.contains('.')) amount += digit;
      } else {
        amount += digit;
      }
    });
  }

  void _saveTransaction() async {
    double amountValue = double.tryParse(amount) ?? 0.0;
    if (amountValue == 0.0) {
      print("Amount cannot be zero");
      return;
    }
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    TransactionModel transaction = TransactionModel(
      amount: amountValue,
      date: formattedDate,
      category: selectedCategory,
      userId: widget.userId,
      type: selectedTypeIndex == 0 ? 'expense' : 'income',
      title: '',
    );

    await _dbHelper.insertTransaction(transaction);
    Navigator.pop(context);
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MM').format(selectedDate);
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              TopBarSwitcher(
                  onToggle: (index) => setState(() => selectedTypeIndex = index),
                  selectedIndex: selectedTypeIndex
              ),
              const SizedBox(height: 32),
              AmountDisplay(
                amount: amount,
                onBackspace: _deleteLast,
              ),
              const SizedBox(height: 16),
              const Spacer(),
              DateTimeCategoryRow(
                date: formattedDate,
                time: selectedTime,
                selectedCategory: selectedCategory,
                categories: categories,
                onSelectDate: _selectDate,
                onSelectTime: _selectTime,
                onCategoryChanged: (value) => setState(() => selectedCategory = value!),
              ),
              SizedBox(height: 16),
              Keypad(
                onDigitPressed: _addDigit,
                onSubmit: _saveTransaction,
              )
            ],
          ),
      ),
    );
  }
}
