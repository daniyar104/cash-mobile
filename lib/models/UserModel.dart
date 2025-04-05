class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? password;
  final double amount;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.amount = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'amount': amount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      amount: map['amount'] ?? 0.0,
    );
  }
}