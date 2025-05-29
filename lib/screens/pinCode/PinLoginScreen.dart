import 'package:flutter/material.dart';
import '../../models/PinService.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
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

  void _deleteLast() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _validatePin() async {
    final savedPin = await _pinService.getSavedPin();
    if (_enteredPin == savedPin) {
      Navigator.pushReplacementNamed(context, '/home'); // 👈 заменено на /main
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Неверный PIN')),
      );
      setState(() => _enteredPin = '');
    }
  }

  Widget _buildPinCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _enteredPin.length
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  Widget _buildKeyboardButton(String value, {bool isDelete = false}) {
    return GestureDetector(
      onTap: isDelete ? _deleteLast : () => _onDigitPressed(value),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: IconOrText(value, isDelete: isDelete),
      ),
    );
  }

  Widget _buildKeyboard() {
    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '', '0', '⌫',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemBuilder: (_, index) {
        final key = keys[index];
        if (key.isEmpty) return const SizedBox.shrink();
        return _buildKeyboardButton(
          key,
          isDelete: key == '⌫',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              "Введите PIN-код",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildPinCircles(),
            const SizedBox(height: 40),
            _buildKeyboard(),
          ],
        ),
      ),
    );
  }
}

class IconOrText extends StatelessWidget {
  final String value;
  final bool isDelete;

  const IconOrText(this.value, {super.key, this.isDelete = false});

  @override
  Widget build(BuildContext context) {
    return isDelete
        ? Icon(Icons.backspace_outlined, color: Theme.of(context).colorScheme.primary)
        : Text(
      value,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
