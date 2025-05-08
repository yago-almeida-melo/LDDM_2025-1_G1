import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> criaTabelaUsuarios(sql.Database database) async {
    await database.execute("""CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        email TEXT,
        senha TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'Visia.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabelaUsuarios(database);
      },
    );
  }

  static Future<int> adicionarUsuario(String nome, String email, String senha) async {
    final db = await SQLHelper.db();

    final dados = {'nome': nome, 'email': email, 'senha': senha};
    final id = await db.insert('usuarios', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> pegaUsuario() async {
    final db = await SQLHelper.db();
    return db.query('usuarios', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> pegaUmUsuario(int id) async {
    final db = await SQLHelper.db();
    return db.query('usuarios', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> atualizaUsuario(
      int id, String nome, String email, String senha) async {
    final db = await SQLHelper.db();

    final dados = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('usuarios', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagaUsuario(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item item: $err");
    }
  }
}