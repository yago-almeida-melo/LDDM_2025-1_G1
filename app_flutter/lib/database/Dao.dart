import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static sql.Database? _database;

  static Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

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

  // Criação da tabela medicamentos
  static Future<void> createTableMedicamentos(sql.Database database) async {
    await database.execute("""
      CREATE TABLE medicamentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        informacoes TEXT,
        textoCompleto TEXT,
        dataAdicao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> initDb() async {
    return sql.openDatabase(
      'visia.db',
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await createTableUser(database);
        await createTableMedicamentos(database);
      },
    );
  }
}
