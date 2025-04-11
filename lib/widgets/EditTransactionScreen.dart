import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/db/app_database_helper.dart';
import 'package:untitled1/models/TransactionModel.dart';

import '../db/database_factory.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food';
  final List<String> _categories = ['Food', 'Transportation', 'Entertainment', 'Shopping', 'Other'];

  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountController.text = widget.transaction.amount.toString();
    _selectedDate = DateTime.parse(widget.transaction.date);
    _selectedCategory = widget.transaction.category!;

  }
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedTransaction = widget.transaction.copyWith(
        amount: double.tryParse(_amountController.text) ?? 0.0,
        category: _selectedCategory,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      );

      await _dbHelper.updateTransaction(updatedTransaction);
      Navigator.pop(context, updatedTransaction);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Category'),
              ),
              Row(
                children: [
                  Expanded(child: Text('Date: ${DateFormat('yyy-MM-dd').format(_selectedDate)}')),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text('Select Date'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _saveChanges();
                },
                child: Text('Save Changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
