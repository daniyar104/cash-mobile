class ScheduledPayment {
  int? id;
  String title;
  double amount;
  DateTime date;
  String category;
  int userId;
  String type; // 'income' или 'expense'

  ScheduledPayment({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.userId,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,  // храним как int для удобства запросов
      'category': category,
      'user_id': userId,
      'type': type,
    };
  }

  factory ScheduledPayment.fromMap(Map<String, dynamic> map) {
    return ScheduledPayment(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      category: map['category'],
      userId: map['user_id'],
      type: map['type'],
    );
  }

}
