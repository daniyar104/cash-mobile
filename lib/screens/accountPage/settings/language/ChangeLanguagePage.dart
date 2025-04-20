  import 'package:flutter/material.dart';
  import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/localization/locales.dart';

  class ChangeLanguagePage extends StatefulWidget {
    const ChangeLanguagePage({super.key});

    @override
    State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
  }

  class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
    late FlutterLocalization _flutterLocalization;
    late String _selectedLanguage;

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _flutterLocalization = FlutterLocalization.instance;
      _selectedLanguage = _flutterLocalization.currentLocale!.languageCode;
      print(_selectedLanguage);
    }

    Future<void> _changeLanguage(String languageCode) async {
      _flutterLocalization.translate(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
      setState(() {
        _selectedLanguage = languageCode;
      });
      Navigator.pop(context);
    }

    Widget _buildLanguageTile(String languageCode, String title) {
      return ListTile(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _selectedLanguage == languageCode
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
        // trailing: _selectedLanguage == languageCode
        //     ? Icon(Icons.check, color: Theme.of(context).primaryColor)
        //     : null,
        onTap: () => _changeLanguage(languageCode),
      );
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              LocalData.language.getString(context),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildLanguageTile('en', 'English'),
              _buildLanguageTile('ru', 'Russian'),
              _buildLanguageTile('kk', 'Kazakh'),
            ],
          ),
        ),
      );
    }
  }
