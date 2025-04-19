import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../localization/locales.dart';

class WelcomeWidget extends StatefulWidget {

  const WelcomeWidget({super.key});

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {

  String getGreeting(){
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return LocalData.morning.getString(context);
    } else if (hour >= 12 && hour < 17) {
      return LocalData.afternoon.getString(context);
    } else if( hour >= 17 && hour < 22) {
      return LocalData.evening.getString(context);
    } else {
      return LocalData.night.getString(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Text(
            "${getGreeting()},",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
