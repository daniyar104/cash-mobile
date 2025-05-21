import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/db/app_database_helper.dart';
import 'package:untitled1/screens/accountPage/settings/SettingsPage.dart';
import 'package:untitled1/screens/accountPage/settings/categories/CategoryListPage.dart';
import 'package:untitled1/screens/accountPage/settings/language/ChangeLanguagePage.dart';
import 'package:untitled1/screens/accountPage/settings/styles/SelectStylePage.dart';
import 'package:untitled1/screens/accountPage/settings/template/TemplatePage.dart';

import '../../db/database_factory.dart';
import '../../localization/locales.dart';
import '../../widgets/ui/SettingsTile.dart';
import '../login/login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final AppDatabaseHelper _dbHelper = getDatabaseHelper();

  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();
  String? _avatarPath;

  late String name = "";
  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarPath = prefs.getString('avatar_path');
      if (_avatarPath != null) {
        _avatarImage = File(_avatarPath!);
      }
    });
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
    await prefs.remove('avatar_path');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("Profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.person,
                  localizationKey: name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text("Operations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.category,
                  localizationKey: "Categories",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryListPage()),
                    );
                  },
                ),
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.new_label_outlined,
                  localizationKey: "Tags",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryListPage()),
                    );
                  },
                ),
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.currency_exchange,
                  localizationKey: "Currency",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryListPage()),
                    );
                  },
                ),
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.language,
                  localizationKey: "Language",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeLanguagePage()),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text("Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.notifications,
                  localizationKey: "Notifications",
                  onTap: () {
                    // Navigate to notifications settings
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text("Security",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.vpn_key,
                  localizationKey: "Key",
                  onTap: () {
                    // Navigate to change password
                  },
                ),
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.lock,
                  localizationKey: "Password",
                  onTap: () {
                    // Navigate to change password
                  },
                ),
              ]
          ),
        ),
      ),
    );
  }
}
