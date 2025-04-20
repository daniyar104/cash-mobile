import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

import '../../localization/locales.dart';

class DateTimeCategoryRow extends StatelessWidget {
  final DateTime selectedDate;
  final String date;
  final String time;
  final List<String> categories;
  final String selectedCategory;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final Function(String?) onCategoryChanged;

  const DateTimeCategoryRow({super.key, required this.date, required this.time, required this.categories, required this.selectedCategory, required this.onSelectDate, required this.onSelectTime, required this.onCategoryChanged, required this.selectedDate});
  String _getLocalizedCategoryName(String key, BuildContext context) {
    switch (key) {
      case 'Food':
        return LocalData.food.getString(context);
      case 'Transportation':
        return LocalData.transportation.getString(context);
      case 'Entertainment':
        return LocalData.entertainment.getString(context);
      case 'Shopping':
        return LocalData.shopping.getString(context);
      case 'Other':
        return LocalData.other.getString(context);
      case 'Health':
        return LocalData.health.getString(context);
      case 'Bills':
        return LocalData.bills.getString(context);
      case 'Utilities':
        return LocalData.utilities.getString(context);
      case 'Salary':
        return LocalData.salary.getString(context);
      case 'Investment':
        return LocalData.investment.getString(context);
      case 'Education':
        return LocalData.education.getString(context);
      case 'Travel':
        return LocalData.travel.getString(context);
      case 'Groceries':
        return LocalData.groceries.getString(context);
      case 'Housing':
        return LocalData.housing.getString(context);
      case 'Leisure':
        return LocalData.leisure.getString(context);
      case 'Gifts':
        return LocalData.gifts.getString(context);
      case 'Donations':
        return LocalData.donations.getString(context);
      case 'Subscriptions':
        return LocalData.subscriptions.getString(context);
      case 'Pets':
        return LocalData.pets.getString(context);
      case 'Insurance':
        return LocalData.insurance.getString(context);
      default:
        return key;
    }
  }

  String _getLocalizedDayOfWeek(DateTime date, BuildContext context) {
    switch (date.weekday) {
      case 1:
        return LocalData.monday.getString(context);
      case 2:
        return LocalData.tuesday.getString(context);
      case 3:
        return LocalData.wednesday.getString(context);
      case 4:
        return LocalData.thursday.getString(context);
      case 5:
        return LocalData.friday.getString(context);
      case 6:
        return LocalData.saturday.getString(context);
      case 7:
        return LocalData.sunday.getString(context);
      default:
        return '';
    }
  }

  String _formatDateDisplay(BuildContext context) {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final formattedDate = DateFormat('d MMM').format(selectedDate);

    if (isToday) {
      return '${LocalData.today.getString(context)}, $formattedDate'; // Только дата, например "20 Apr"
    } else {
      final dayOfWeek = _getLocalizedDayOfWeek(selectedDate, context);
      return '$dayOfWeek, $formattedDate'; // Например, "Пятница, 19 Apr"
    }
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
                Text(_formatDateDisplay(context)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onSelectTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(time),
          ),
        ),
        const SizedBox(width: 5),
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
              child: Text(_getLocalizedCategoryName(value, context)),
            )).toList(),
            underline: const SizedBox(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
