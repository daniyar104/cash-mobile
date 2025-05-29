import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencySettingsPage extends StatefulWidget {
  const CurrencySettingsPage({super.key});

  @override
  State<CurrencySettingsPage> createState() => _CurrencySettingsPageState();
}

class _CurrencySettingsPageState extends State<CurrencySettingsPage> {
  String _selectedCurrency = 'KZT';
  final List<String> _currencies = ['KZT', 'USD', 'EUR', 'RUB'];

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrency = prefs.getString('currency') ?? 'KZT';
    setState(() {
      _selectedCurrency = savedCurrency;
    });
  }

  Future<void> _saveCurrency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', value);
    setState(() {
      _selectedCurrency = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Валюта обновлена')),
    );

    Navigator.pop(context); // Вернуться назад
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор валюты')),
      body: ListView.builder(
        itemCount: _currencies.length,
        itemBuilder: (context, index) {
          final currency = _currencies[index];
          return RadioListTile<String>(
            title: Text(currency),
            value: currency,
            groupValue: _selectedCurrency,
            onChanged: (value) {
              if (value != null) _saveCurrency(value);
            },
          );
        },
      ),
    );
  }
}
