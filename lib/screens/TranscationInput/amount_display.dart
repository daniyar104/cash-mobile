import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmountDisplay extends StatelessWidget {
  final String amount;
  final VoidCallback onBackspace;

  const AmountDisplay({
    super.key,
    required this.amount,
    required this.onBackspace,
  });

  Future<String> _getCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    final currency = prefs.getString('currency') ?? 'KZT';
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'RUB':
        return '₽';
      case 'KZT':
      default:
        return '₸';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getCurrencySymbol(),
      builder: (context, snapshot) {
        final symbol = snapshot.data ?? '₸';

        return Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                '$symbol ${amount.isEmpty ? '0.00' : amount}',
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
      },
    );
  }
}
