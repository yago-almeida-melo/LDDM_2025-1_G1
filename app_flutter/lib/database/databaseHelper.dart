import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Databasehelper {
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

  static Future<void> createTableMedicament(sql.Database database) async {
    await database.execute("""CREATE TABLE medicamentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        efeitosColaterais TEXT,
        forma TEXT,
        fabricante TEXT,
        composicao TEXT,
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
}