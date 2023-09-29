import '../helper/database_helper.dart';
import '../model/user.dart';

class LoginController {
DatabaseHelper con = DatabaseHelper();

Future<int> saveUser(User user) async {
  var db = await con.db;

  int result = await db.insert("user", user.toMap());

  return result;
}

Future<int> deleteUser(User user) async {
  var db = await con.db;

  int result = await db.delete("user", where: "id=?", whereArgs: [user.id]);

  return result;
}

// a partir do user e senha, tenta pegar o login
Future<User> getLogin(String email, String password) async {
  var db = await con.db;

  String sql = """
  SELECT * FROM user 
  WHERE email='$email' AND password='$password';
  """;

  var result = await db.rawQuery(sql);

  if (result.isNotEmpty) {
    return User.fromMap(result.first);
  }

  return User(
    id: -1,
    email: "",
    name: "",
    password: "",
    matricula: "",
    is_teacher: -1,
  );
}
}
