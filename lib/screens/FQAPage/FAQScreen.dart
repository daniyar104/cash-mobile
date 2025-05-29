import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../localization/locales.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqList = const [
    {
      "question": "Как добавить доход или расход?",
      "answer": "Нажмите на кнопку ➕ на главном экране, выберите категорию, введите сумму и описание. Доходы и расходы будут отображаться в общем балансе."
    },
    {
      "question": "Можно ли редактировать или удалить запись?",
      "answer": "Да. В списке транзакций смахните запись влево для удаления, либо нажмите на неё для редактирования."
    },
    {
      "question": "Что такое категории расходов?",
      "answer": "Категории помогают отслеживать, куда уходят деньги. Примеры: 'Еда', 'Транспорт', 'Развлечения'. Вы можете добавлять и редактировать категории."
    },
    {
      "question": "Как работает статистика?",
      "answer": "Раздел статистики показывает графики и аналитику по вашим доходам и расходам — по дням, неделям и месяцам. Это помогает находить лишние траты."
    },
    {
      "question": "Мои данные в безопасности?",
      "answer": "Да. Все данные хранятся локально на вашем устройстве. Вы также можете включить PIN-код или биометрию для защиты доступа."
    },
    {
      "question": "Как сделать резервную копию?",
      "answer": "В разделе 'Настройки' → 'Резервное копирование' вы можете экспортировать данные или настроить автосохранение в облако (в будущем)."
    },
    {
      "question": "Как переключаться между темами?",
      "answer": "Откройте настройки → Внешний вид и выберите между светлой и тёмной темой. Вы также можете включить авто-настройку по времени суток."
    },
    {
      "question": "Приложение платное?",
      "answer": "Нет, базовая версия бесплатна навсегда. В будущем может появиться PRO-версия с дополнительными функциями, такими как облачное хранилище или продвинутая аналитика."
    },
  ];

  @override
  Widget build(BuildContext context) {
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
