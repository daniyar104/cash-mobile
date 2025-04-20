import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../localization/locales.dart';

class TopBarSwitcher extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onToggle;
  const TopBarSwitcher({super.key, required this.onToggle, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 30),
          ),
        ),
        const SizedBox(width: 60),
        ToggleButtons(
          borderRadius: BorderRadius.circular(30),
          isSelected: [selectedIndex == 0, selectedIndex == 1],
          onPressed: onToggle,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text(LocalData.expenses.getString(context))),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text(LocalData.income.getString(context))),
          ],
        ),
      ],
    );
  }
}
