import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:untitled1/localization/locales.dart';
import 'package:untitled1/widgets/ui/SettingsTile.dart';

import 'language/ChangeLanguagePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.settings.getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SettingsTile(
              leadingIcon: Icons.language,
              localizationKey: LocalData.language.getString(context),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeLanguagePage(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            SettingsTile(
              leadingIcon: Icons.notifications,
              localizationKey: LocalData.pushNotifications.getString(context),
            )
          ],
        ),
      ),
    );
  }
}
