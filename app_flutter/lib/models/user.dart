import 'package:flutter/material.dart'; 

class User {
  final int? id;
  final String nome;
  final String email;
  final String? password;

  User({
    this.id,
    required this.nome,
    required this.email,
    this.password,
  });

    factory User.fromJson(Map<String, dynamic> json) {
      return User(
        id: json['id'],
        nome: json['nome'],
        email: json['email'],
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
