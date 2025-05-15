import 'package:flutter/material.dart'; 

class Medicamento {
  final int id;
  final String nome;
  final String? efeitosColaterias;
  final String? forma;
  final String? fabricante;
  final String? composicao;


  Medicamento({
    required this.id,
    required this.nome,
    this.efeitosColaterias,
    this.forma,
    this.fabricante,
    this.composicao
  });

    factory Medicamento.fromJson(Map<String, dynamic> json) {
      return Medicamento(
        id: json['id'],
        nome: json['nome'],
        efeitosColaterias: json['efeitosColaterais'],
        forma: json['forma'],
        fabricante: json['fabricante'],
        composicao: json['composicao']
      );
  }

  // // Converter de Map (usado pelo SQLite)
  // factory User.fromMap(Map<String, dynamic> map) {
  //   return User(
  //     id: map['id'],
  //     name: map['name'],
  //     email: map['email'],
  //     password: map['password'],
  //   );
  // }

  // // Converter para Map (usado para inserir no banco)
  // Map<String, dynamic> toMap() {
  //   final map = {
  //     'name': name,
  //     'email': email,
  //     'password': password,
  //   };
  //   if (id != null) map['id'] = id;
  //   return map;
  // }
}
