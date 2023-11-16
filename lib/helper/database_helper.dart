import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper.constInterno();
  static Database? _db;

  factory DatabaseHelper() => _instancia;

  DatabaseHelper.constInterno();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, "data.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql_user = """
        CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL,
            matricula VARCHAR NOT NULL,
            is_teacher INTEGER NOT NULL
        );""";

        await db.execute(sql_user);


        for (int i = 1; i < 6; i++) {
          String sql_insert_user =
              "INSERT INTO user(name, email, password, matricula, is_teacher) VALUES('Aluno $i', 'aluno$i@teste', '123456', '221001234', '0');";
          await db.execute(sql_insert_user);
        }
      },
    );
    return db;
  }
}
