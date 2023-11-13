import 'dart:convert';

class passwords {
  final String userName;
  final String description;
  final String password;

  passwords({
    required this.userName,
    required this.description,
    required this.password,
  });

  passwords copyWith({
    String? userName,
    String? description,
    String? password,
  }) {
    return passwords(
      userName: userName ?? this.userName,
      description: description ?? this.description,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'description': description,
      'password': password,
    };
  }

  factory passwords.fromMap(Map<String, dynamic> map) {
    return passwords(
      userName: map['userName'] as String,
      description: map['description'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory passwords.fromJson(String source) =>
      passwords.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'passwords(userName: $userName, description: $description, password: $password)';

  @override
  bool operator ==(covariant passwords other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.description == description &&
        other.password == password;
  }

  @override
  int get hashCode =>
      userName.hashCode ^ description.hashCode ^ password.hashCode;
}
