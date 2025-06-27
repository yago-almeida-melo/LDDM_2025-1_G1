import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:app_flutter/database/Dao.dart';

class MedicamentoDAO {
  // Criação da tabela medicamentos

  // Inserção de novo medicamento
  static Future<int> insertMedicamento(
      String nome, String informacoes, String textoCompleto) async {
    final db = await DatabaseHelper.database;

    final dados = {
      'nome': nome,
      'informacoes': informacoes,
      'textoCompleto': textoCompleto,
      'dataAdicao': DateTime.now().toString()
    };

    final id = await db.insert('medicamentos', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Buscar todos os medicamentos
  static Future<List<Map<String, dynamic>>> getAllMedicamentos() async {
    final db = await DatabaseHelper.database;
    return db.query('medicamentos', orderBy: "dataAdicao DESC");
  }

  // Buscar um medicamento por nome
  static Future<List<Map<String, dynamic>>> getMedicamentoByNome(
      String nome) async {
    final db = await DatabaseHelper.database;
    return db.query(
      'medicamentos',
      where: "nome = ?",
      whereArgs: [nome],
      limit: 1,
    );
  }

  // Atualizar medicamento
  static Future<int> updateMedicamento(
      int id, String nome, String informacoes, String textoCompleto) async {
    final db = await DatabaseHelper.database;

    final dados = {
      'nome': nome,
      'informacoes': informacoes,
      'textoCompleto': textoCompleto,
      'dataAdicao': DateTime.now().toString()
    };

    return await db
        .update('medicamentos', dados, where: "id = ?", whereArgs: [id]);
  }

  // Remover medicamento por id
  static Future<void> deleteMedicamento(int id) async {
    final db = await DatabaseHelper.database;
    try {
      await db.delete("medicamentos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar medicamento: $err");
    }
  }
}
