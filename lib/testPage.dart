import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'localization/locales.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: Text(LocalData.title.getString(context))
      ),
    );
  }
}
