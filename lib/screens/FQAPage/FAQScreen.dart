import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:path/path.dart';

import '../../localization/locales.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        "question": LocalData.question1.getString(context),
        "answer": LocalData.answer1.getString(context),
      },
      {
        "question": LocalData.question2.getString(context),
        "answer": LocalData.answer2.getString(context),
      },
      {
        "question": LocalData.question3.getString(context),
        "answer": LocalData.answer3.getString(context),
      },
      {
        "question": LocalData.question4.getString(context),
        "answer": LocalData.answer4.getString(context),
      },
      {
        "question": LocalData.question5.getString(context),
        "answer": LocalData.answer5.getString(context),
      },
      {
        "question": LocalData.question6.getString(context),
        "answer": LocalData.answer6.getString(context),
      },
      {
        "question": LocalData.question7.getString(context),
        "answer": LocalData.answer7.getString(context),
      },
      {
        "question": LocalData.question8.getString(context),
        "answer": LocalData.answer8.getString(context),
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.faq.getString(context)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
            color: Theme.of(context).colorScheme.surfaceVariant,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(
                item['question']!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Text(
                  item['answer']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
