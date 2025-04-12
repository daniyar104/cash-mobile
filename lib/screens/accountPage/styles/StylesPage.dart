import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../localization/locales.dart';
import '../../../widgets/ui/SettingsTile.dart';

class StylesPage extends StatefulWidget {
  const StylesPage({super.key});

  @override
  State<StylesPage> createState() => _StylesPageState();
}

class _StylesPageState extends State<StylesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.stylesSetting.getString(context)),
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
            // SettingsTile(
            //   leadingIcon: Icons.color_lens,
            //   //localizationKey: LocalData.theme.getString(context),
            // ),
            // SizedBox(height: 10),
            // SettingsTile(
            //   leadingIcon: Icons.font_download,
            //   localizationKey: LocalData.fontSize.getString(context),
            // ),
          ],
        ),
      ),
    );
  }
}
