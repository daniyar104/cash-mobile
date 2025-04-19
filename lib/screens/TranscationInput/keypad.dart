import 'package:flutter/material.dart';
class Keypad extends StatelessWidget {
  final void Function(String) onDigitPressed;
  final VoidCallback onSubmit;
  const Keypad({super.key, required this.onDigitPressed, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final buttons = ['1','2','3','4','5','6','7','8','9','.','0','✔'];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shrinkWrap: true,
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final value = buttons[index];
        final isSubmit = value == '✔';
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSubmit ? Theme.of(context).colorScheme.primary : Colors.grey[200],
            foregroundColor: isSubmit ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            if (isSubmit) {
              onSubmit();
            } else {
              onDigitPressed(value);
            }
          },
          child: Text(value, style: const TextStyle(fontSize: 20)),
        );
      },
    );
  }
}
