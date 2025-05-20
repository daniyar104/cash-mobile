import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:untitled1/localization/locales.dart';
class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/onboarding1.png',
          width: 300,
          height: 300,
        ),
        const SizedBox(height: 20),
        Text(
          LocalData.onboardingTitle01.getString(context),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          LocalData.onboardingBodyText01.getString(context),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
