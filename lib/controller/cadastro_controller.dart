import 'package:chamada_inteligente/helper/database_helper.dart';
import 'package:chamada_inteligente/model/user.dart';

class CadastroController {
  DatabaseHelper con = DatabaseHelper();

  Future<int> saveUser(User user) async {
    var matriculaExists = await isMatriculaExist(user.matricula);

    if (matriculaExists) {
      // A matrícula já existe, você pode lidar com isso da maneira que preferir.
      // Neste exemplo, estamos retornando -1 para indicar que o cadastro é inválido.
      return -1;
    }

    var db = await con.db;

    int result = await db.insert("user", user.toMap());

    return result;
  }

  Future<int> deleteUser(User user) async {
    var db = await con.db;

    int result = await db.delete("user", where: "id=?", whereArgs: [user.id]);

    return result;
  }

  Future<User> getCadastro(String name, String password) async {
    var db = await con.db;

    String sql = """
    SELECT * FROM user 
    WHERE name='$name' AND password='$password';
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
      is_teacher: "",
    );
  }

  Future<bool> verifyEmail(String email) async {
    var db = await con.db;

    String sql = """
    SELECT * FROM user 
    WHERE email='$email';
    """;

    var result = await db.rawQuery(sql);

    if (result.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> isMatriculaExist(String matricula) async {
    var db = await con.db;

    String sql = """
    SELECT * FROM user 
    WHERE matricula='$matricula';
    """;

    var result = await db.rawQuery(sql);

    return result
        .isNotEmpty; // Retorna true se a matrícula já existe, caso contrário, retorna false.
  }
}
