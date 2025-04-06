import 'package:flutter/material.dart';
import 'package:untitled1/models/TransactionModel.dart';

class EditTransactionScreen extends StatelessWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Category: ${transaction.category}'),
            Text('Amount: ${transaction.amount}'),
            Text('Date: ${transaction.date}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add form and save logic here
              },
              child: Text('Save Changes'),
            )
          ],
        ),
      ),
    );
  }
}
