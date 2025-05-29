import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Color _selectedColor = Colors.blue;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.deepPurple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    isDark = widget.currentThemeMode == ThemeMode.dark;
    _loadColor();
  }

  Future<void> _loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('theme_color') ?? Colors.blue.value;
    setState(() {
      _selectedColor = Color(colorValue);
    });
  }

  Future<void> _saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_color', color.value);
    setState(() {
      _selectedColor = color;
    });
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки темы')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Тёмная тема'),
            value: isDark,
            onChanged: (val) {
              setState(() {
                isDark = val;
              });
              widget.onToggleTheme();
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Выберите цвет темы:", style: TextStyle(fontSize: 16)),
          ),
          Wrap(
            spacing: 10,
            children: _availableColors.map((color) {
              return GestureDetector(
                onTap: () => _saveColor(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == color
                          ? Theme.of(context).colorScheme.onBackground
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
