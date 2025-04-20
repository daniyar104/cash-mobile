import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/db/database_factory.dart';
import 'package:untitled1/screens/TranscationInput/top_bar_switcher.dart';
import '../localization/locales.dart';
import '../models/TransactionModel.dart';
import '../utils/categories.dart';
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
  String selectedCategory = '';
  int selectedTypeIndex = 0;
  late List<String> categories;

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    _filterCategories();
  }

  void _filterCategories() {
    if (selectedTypeIndex == 0) {
      // Expense
      categories = categoriesList;
    } else {
      // Income
      categories = categoriesList;
    }
    if (categories.isNotEmpty) {
      selectedCategory = categories[0];
    } else {
      selectedCategory = '';
    }
    setState(() {});
  }
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
      return;
    }
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedTime = selectedTime.format(context);
    TransactionModel transaction = TransactionModel(
      amount: amountValue,
      date: formattedDate,
      time:formattedTime,
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
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  /// Вернуить так чтобы время можно было стравить на перед
  /// ну или так и оставить чтобы выводить сообщения на разных языках
  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      // Если выбрана сегодняшняя дата, ограничиваем время
      final now = DateTime.now();
      final isToday = selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day;
      if (isToday) {
        final currentTime = TimeOfDay.fromDateTime(now);
        final pickedMinutes = picked.hour * 60 + picked.minute;
        final currentMinutes = currentTime.hour * 60 + currentTime.minute;
        if (pickedMinutes > currentMinutes) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot select a future time for today'),
            ),
          );
          return;
        }
      }
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
                  onToggle: (index) {
                    setState(() {
                      selectedTypeIndex = index;
                      _filterCategories();
                    });
                  },
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
                selectedDate: selectedDate,
                date: formattedDate,
                time: selectedTime.format(context),
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
