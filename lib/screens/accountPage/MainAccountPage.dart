import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/db/app_database_helper.dart';
import 'package:untitled1/screens/accountPage/settings/SettingsPage.dart';
import 'package:untitled1/screens/accountPage/settings/styles/SelectStylePage.dart';
import 'package:untitled1/screens/accountPage/settings/template/TemplatePage.dart';

import '../../db/database_factory.dart';
import '../../localization/locales.dart';
import '../../widgets/ui/SettingsTile.dart';
import '../login/login_page.dart';

class MainAcountPage extends StatefulWidget {
  const MainAcountPage({super.key});

  @override
  State<MainAcountPage> createState() => _MainAcountPageState();
}

class _MainAcountPageState extends State<MainAcountPage> {
  final AppDatabaseHelper _dbHelper = getDatabaseHelper();
  late String name = "";
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<String?> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final users = await _dbHelper.getUsers();
      final user = users.firstWhere((user) => user.id == userId);
      name = user.username!;
      setState(() {});
    }
    return name;
  }
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.account.getString(context)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                // image: DecorationImage(
                //   image: AssetImage('assets/images/user.png'),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            Text(name!, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            SettingsTile(
                leadingIcon: Icons.settings,
                localizationKey: LocalData.settings.getString(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                }
            ),
            SizedBox(height: 10),
            SettingsTile(
                leadingIcon: Icons.style,
                localizationKey: LocalData.stylesSetting.getString(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectStylePage(),
                    ),
                  );
                }
            ),
            SizedBox(height: 10),
            SettingsTile(
                leadingIcon: Icons.class_outlined,
                localizationKey: LocalData.templateSetting.getString(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TemplatePage(),
                    ),
                  );
                }
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _logout,
            //   child: Text(LocalData.logout.getString(context)),
            // ),
            // Center(
            //   child: DropdownButton(
            //     value: _selectedLanguage,
            //     items: const [
            //       DropdownMenuItem(value: "en", child: Text("English")),
            //       DropdownMenuItem(value: "ru", child: Text("Russian")),
            //     ],
            //     onChanged: (value) {
            //       _setLocal(value);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}