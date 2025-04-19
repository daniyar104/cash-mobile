import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Icons.fastfood; // Иконка для еды
    case 'transportation':
      return Icons.directions_bus; // Иконка для транспорта
    case 'shopping':
      return Icons.shopping_cart; // Иконка для покупок
    case 'entertainment':
      return Icons.movie; // Иконка для развлечений
    case 'health':
      return Icons.health_and_safety; // Иконка для здоровья
    case 'bills':
      return Icons.receipt; // Иконка для счетов
    case 'utilities':
      return Icons.home_repair_service; // Иконка для коммунальных услуг
    case 'salary':
      return Icons.attach_money; // Иконка для зарплаты
    case 'investment':
      return Icons.trending_up; // Иконка для инвестиций
    case 'education':
      return Icons.school; // Иконка для образования
    case 'travel':
      return Icons.airplane_ticket; // Иконка для путешествий
    case 'groceries':
      return Icons.local_grocery_store; // Иконка для продуктов
    case 'housing':
      return Icons.house; // Иконка для жилья
    case 'leisure':
      return Icons.pool; // Иконка для досуга
    case 'gifts':
      return Icons.card_giftcard; // Иконка для подарков
    case 'donations':
      return Icons.volunteer_activism; // Иконка для пожертвований
    case 'subscriptions':
      return Icons.subscriptions; // Иконка для подписок
    case 'pets':
      return Icons.pets; // Иконка для животных
    case 'insurance':
      return Icons.security; // Иконка для страховки
    default:
      return Icons.category; // Иконка по умолчанию
  }
}
