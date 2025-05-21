import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final VoidCallback onToggleTheme;

  const ThemeSettingsPage({
    super.key,
    required this.currentThemeMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки темы')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Тёмная тема'),
          value: isDark,
          onChanged: (val) {
            onToggleTheme();
          },
        ),
      ),
    );
  }
}
