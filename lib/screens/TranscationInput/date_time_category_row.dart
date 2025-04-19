import 'package:flutter/material.dart';

class DateTimeCategoryRow extends StatelessWidget {
  final String date;
  final TimeOfDay time;
  final List<String> categories;
  final String selectedCategory;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final Function(String?) onCategoryChanged;

  const DateTimeCategoryRow({super.key, required this.date, required this.time, required this.categories, required this.selectedCategory, required this.onSelectDate, required this.onSelectTime, required this.onCategoryChanged});
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onSelectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text('Today, $date'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onSelectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(formatTimeOfDay(time)),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: selectedCategory,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
            onChanged: onCategoryChanged,
            items: categories.map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            )).toList(),
            underline: const SizedBox(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
