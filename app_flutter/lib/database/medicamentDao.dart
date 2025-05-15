import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'databaseHelper.dart';

class Medicamentdao {

  static Future<int> insertMedicament(String nome, String efeitosColaterais, String forma, String fabricante, String composicao) async {
    final db = await Databasehelper.db();

    final dados = {'nome': nome, 'efeitosColaterais': efeitosColaterais, 'forma': forma, 'fabricante': fabricante, 'composicao': composicao};
    final id = await db.insert('medicamentos', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllMedicaments() async {
    final db = await Databasehelper.db();
    return db.query('medicamentos', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getMedicament(int id) async {
    final db = await Databasehelper.db();
    return db.query('usuarios', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateMedicament(int id, String nome, String efeitosColaterais, String forma, String fabricante, String composicao) async {
    final db = await Databasehelper.db();

    final dados = {
      'nome': nome, 
      'efeitosColaterais': efeitosColaterais, 
      'forma': forma, 
      'fabricante': fabricante, 
      'composicao': composicao,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('medicamentos', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteMedicament(int id) async {
    final db = await Databasehelper.db();
    try {
      await db.delete("medicamentos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item: $err");
    }
  }
}