// pin_login_screen.dart
import 'package:flutter/material.dart';
import '../../models/PinService.dart';

class PinLoginScreen extends StatefulWidget {
  @override
  _PinLoginScreenState createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String _enteredPin = '';
  final PinService _pinService = PinService();

  void _onDigitPressed(String digit) {
    if (_enteredPin.length < 4) {
      setState(() => _enteredPin += digit);

      if (_enteredPin.length == 4) _validatePin();
    }
  }

  void _validatePin() async {
    final savedPin = await _pinService.getSavedPin();
    if (_enteredPin == savedPin) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Неверный PIN')));
      setState(() => _enteredPin = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Введите PIN-код", style: TextStyle(fontSize: 24)),
          Text(_enteredPin.replaceAll(RegExp('.'), '●'), style: TextStyle(fontSize: 32)),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(10, (index) {
              return ElevatedButton(
                onPressed: () => _onDigitPressed(index.toString()),
                child: Text(index.toString()),
              );
            }),
          ),
        ],
      ),
    );
  }
}
