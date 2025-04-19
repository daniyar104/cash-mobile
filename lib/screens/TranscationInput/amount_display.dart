import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  final String amount;
  final VoidCallback onBackspace;
  const AmountDisplay({super.key, required this.amount, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            '₸ ${amount.isEmpty ? '0.00' : amount}',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.backspace_outlined),
          onPressed: onBackspace,
        ),
      ],
    );
  }
}
