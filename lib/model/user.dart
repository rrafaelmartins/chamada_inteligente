import 'dart:convert';

class User {
  int? id;
  String email;
  String name;
  String password;
  String matricula;
  int? is_teacher;

  User(
      {this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.matricula,
      required this.is_teacher});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "email": email,
      "name": name,
      "password": password,
      "matricula": matricula,
      "is_teacher": is_teacher
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map["id"],
        email: map["email"],
        name: map["name"],
        password: map["password"],
        matricula: map["matricula"],
        is_teacher: map["is_teacher"],);
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
