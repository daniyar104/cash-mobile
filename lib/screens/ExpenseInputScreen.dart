import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database_helper.dart';
import '../models/TransactionModel.dart';

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
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    TransactionModel transaction = TransactionModel(
      amount: amountValue,
      date: formattedDate,
      category: selectedCategory,
      userId: widget.userId,
      type: selectedTypeIndex == 0 ? 'expense' : 'income',
      title: '',
    );

    await DataBaseHelper.instance.insertTransaction(transaction);

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
    final dateString = DateFormat('d MMM').format(selectedDate);
    final timeString = selectedTime.format(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.close),
                  ),
                ),
                const SizedBox(width: 60),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(30),
                  isSelected: [selectedTypeIndex == 0, selectedTypeIndex == 1],
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Expense')),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Income')),
                  ],
                  onPressed: (index) {
                    setState(() {
                      selectedTypeIndex = index;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                    '₸ ${amount.isEmpty ? '0.00' : amount}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.backspace_outlined),
                    onPressed: _deleteLast,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text('Today, $dateString'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(timeString),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 14,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    underline: SizedBox(),
                    isDense: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final buttons = ['1','2','3','4','5','6','7','8','9','.','0','✔'];
                  final value = buttons[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: value == '✔' ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                      foregroundColor: value == '✔' ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (value == '✔') {
                        _saveTransaction();
                      } else {
                        _addDigit(value);
                      }
                    },
                    child: Text(value, style: const TextStyle(fontSize: 20)),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}
