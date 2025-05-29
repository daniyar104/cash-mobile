import 'package:flutter/material.dart';
import '../../models/PinService.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final PinService _pinService = PinService();
  String _currentStep = 'verify'; // verify or new
  String _input = '';
  String _newPin = '';

  void _onDigitPressed(String digit) {
    if (_input.length < 4) {
      setState(() => _input += digit);
      if (_input.length == 4) {
        if (_currentStep == 'verify') {
          _verifyCurrentPin();
        } else {
          _saveNewPin();
        }
      }
    }
  }

  void _deleteLast() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
      });
    }
  }

  void _verifyCurrentPin() async {
    final savedPin = await _pinService.getSavedPin();
    if (_input == savedPin) {
      setState(() {
        _input = '';
        _currentStep = 'new';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Неверный текущий PIN')),
      );
      setState(() => _input = '');
    }
  }

  void _saveNewPin() async {
    await _pinService.savePin(_input);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ PIN успешно изменён')),
    );
    Navigator.pop(context); // возвращаемся назад
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
            color: index < _input.length
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
    final title = _currentStep == 'verify' ? 'Введите текущий PIN' : 'Введите новый PIN';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Смена PIN-кода"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              title,
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
