import 'package:flutter/material.dart';

class SelectStylePage extends StatefulWidget {
  const SelectStylePage({super.key});

  @override
  State<SelectStylePage> createState() => _SelectStylePageState();
}

class _SelectStylePageState extends State<SelectStylePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Style'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select your style'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: Text('Select Style 1'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: Text('Select Style 2'),
            ),
          ],
        ),
      ),
    );
  }
}
