import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/screens/TransactionsListPage.dart';
import '../db/database_helper.dart';
import '../models/TransactionModel.dart';

class AddTransactionForm extends StatefulWidget {
  final int userId;

  const AddTransactionForm({Key? key, required this.userId}) : super(key: key);

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm>{
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  String _type = 'expense';

  Future<void> _addTransaction() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final transaction = TransactionModel(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date:formattedDate,
        category: _categoryController.text,
        userId: widget.userId,
        type: _type,
      );
      await DataBaseHelper.instance.insertTransaction(transaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextFormField(controller: _amountController, decoration: InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            TextFormField(controller: _categoryController, decoration: InputDecoration(labelText: 'Category')),
            DropdownButtonFormField(
              value: _type,
              items: ['income', 'expense'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _type = value.toString();
                });
              },
            ),
            ElevatedButton(onPressed: _addTransaction, child: Text('Add')),
          ],
        ),
      ),
    );
  }
}
