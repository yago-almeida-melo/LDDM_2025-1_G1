import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //Função para criar a tabela de usuários
  static Future<void> createTableUser(sql.Database database) async {
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
      'visia.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTableUser(database);
      },
    );
  }

  static Future<int> insertUser(String nome, String email, String senha) async {
    final db = await SQLHelper.db();

    final dados = {'nome': nome, 'email': email, 'senha': senha};
    final id = await db.insert('usuarios', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await SQLHelper.db();
    return db.query('usuarios', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUser(String email) async {
    final db = await SQLHelper.db();
    return db.query('usuarios', where: "email = ?", whereArgs: [email], limit: 1);
  }

  static Future<int> updateUser(
      int id, String nome, String email, String senha) async {
    final db = await SQLHelper.db();

    final dados = {
      'nome': nome,
      'valor': valor,
      'ean': ean,
      'qte': qte,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('produtos', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagaProduto(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("produtos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item item: $err");
    }
  }
}