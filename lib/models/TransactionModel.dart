class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String time;
  final String? category;
  final int userId;
  final String type;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
    required this.category,
    required this.userId,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'time': time,
      'category': category,
      'user_id': userId,
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
      time: map['time'],
      category: map['category'],
      userId: map['user_id'],
      type: map['type'],
    );
  }
  TransactionModel copyWith({
    int? id,
    double? amount,
    String? date,
    String? time,
    String? category,
    String? type,
    String? title,
    int? userId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      type: type ?? this.type,
      title: title ?? this.title,
      userId: userId ?? this.userId,
    );
  }

}