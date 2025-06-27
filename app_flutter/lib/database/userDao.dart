import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:app_flutter/database/Dao.dart';

class SQLHelper {
  //Função para criar a tabela de usuários

  static Future<int> insertUser(String nome, String email, String senha) async {
    final db = await DatabaseHelper.database;
    final dados = {'nome': nome, 'email': email, 'senha': senha};
    final id = await db.insert('usuarios', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DatabaseHelper.database;
    return db.query('usuarios', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUser(String email) async {
    final db = await DatabaseHelper.database;
    return db.query('usuarios',
        where: "email = ?", whereArgs: [email], limit: 1);
  }

  static Future<int> updateUser(
      int id, String nome, String email, String senha) async {
    final db = await DatabaseHelper.database;

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

  static Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.database;
    try {
      await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item: $err");
    }
  }
}
