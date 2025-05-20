import 'package:flutter/material.dart';

class PlanningsPage extends StatefulWidget {
  const PlanningsPage({super.key});

  @override
  State<PlanningsPage> createState() => _PlanningsPageState();
}

class _PlanningsPageState extends State<PlanningsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Plannings',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
