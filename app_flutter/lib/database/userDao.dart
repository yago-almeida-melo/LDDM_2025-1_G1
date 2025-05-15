import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'databaseHelper.dart';

class Userdao {

  static Future<int> insertUser(String nome, String email, String senha) async {
    final db = await Databasehelper.db();

    final dados = {'nome': nome, 'email': email, 'senha': senha};
    final id = await db.insert('usuarios', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await Databasehelper.db();
    return db.query('usuarios', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUser(String email) async {
    final db = await Databasehelper.db();
    return db.query('usuarios', where: "email = ?", whereArgs: [email], limit: 1);
  }

  static Future<int> updateUser(String nome, String email, String senha) async {
    final db = await Databasehelper.db();

    final dados = {
      'nome': nome,
      'email': email,
      'senha': senha,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('usuarios', dados, where: "email = ?", whereArgs: [email]);
    return result;
  }

  static Future<void> deleteUser(int id) async {
    final db = await Databasehelper.db();
    try {
      await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item: $err");
    }
  }
}