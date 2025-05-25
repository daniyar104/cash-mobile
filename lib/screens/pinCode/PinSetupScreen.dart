// pin_setup_screen.dart
import 'package:flutter/material.dart';
import '../../models/PinService.dart';

class PinSetupScreen extends StatefulWidget {
  @override
  _PinSetupScreenState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';
  final PinService _pinService = PinService();

  void _onDigitPressed(String digit) {
    if (_pin.length < 4) {
      setState(() => _pin += digit);
      if (_pin.length == 4) _savePin();
    }
  }

  void _savePin() async {
    await _pinService.savePin(_pin);
    Navigator.pushReplacementNamed(context, '/login'); // переходим к входу
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Создайте PIN", style: TextStyle(fontSize: 24)),
          Text(_pin.replaceAll(RegExp('.'), '●'), style: TextStyle(fontSize: 32)),
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
