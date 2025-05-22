import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final VoidCallback onToggleTheme;

  const ThemeSettingsPage({
    super.key,
    required this.currentThemeMode,
    required this.onToggleTheme,
  });

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.currentThemeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки темы')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Тёмная тема'),
          value: isDark,
          onChanged: (val) {
            setState(() {
              isDark = val;
            });
            widget.onToggleTheme();
          },
        ),
      ),
    );
  }
}
