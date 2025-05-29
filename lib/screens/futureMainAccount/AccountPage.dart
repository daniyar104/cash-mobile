import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/db/app_database_helper.dart';
import 'package:untitled1/screens/FQAPage/FAQScreen.dart';
import 'package:untitled1/screens/accountPage/settings/SettingsPage.dart';
import 'package:untitled1/screens/accountPage/settings/categories/CategoryListPage.dart';
import 'package:untitled1/screens/accountPage/settings/language/ChangeLanguagePage.dart';
import 'package:untitled1/screens/accountPage/settings/template/TemplatePage.dart';

import '../../db/database_factory.dart';
import '../../localization/locales.dart';
import '../../widgets/ui/SettingsTile.dart';
import '../NotificationPage/NotificationTestPage.dart';
import '../accountPage/settings/styles/ThemeSettingsPage.dart';
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
        title: Text(LocalData.account.getString(context)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(LocalData.profile.getString(context),
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
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.question_mark,
                  localizationKey: LocalData.faq.getString(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQScreen()),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text(LocalData.operations.getString(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.category,
                  localizationKey: LocalData.categories.getString(context),
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
                  localizationKey: LocalData.currency.getString(context),
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
                  localizationKey: LocalData.language.getString(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeLanguagePage()),
                    );
                  },
                ),
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.motion_photos_on_rounded,
                  localizationKey: LocalData.stylesSetting.getString(context),
                  onTap: () {
                    Navigator.pushNamed(context, '/themeSettings');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text(LocalData.pushNotifications.getString(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.notifications,
                  localizationKey: LocalData.pushNotifications.getString(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationTestPage()),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text(LocalData.security.getString(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.vpn_key,
                  localizationKey: LocalData.key.getString(context),
                  onTap: () {
                    // Navigate to change password
                  },
                ),
                SizedBox(height: 5),
                SettingsTile(
                  leadingIcon: Icons.lock,
                  localizationKey: LocalData.password.getString(context),
                  onTap: () {
                    // Navigate to change password
                  },
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text(LocalData.logoutButton.getString(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SettingsTile(
                  leadingIcon: Icons.logout,
                  localizationKey: LocalData.logoutButton.getString(context),
                  onTap: () {
                    _logout();
                  },
                ),
              ]
          ),
        ),
      ),
    );
  }
}
