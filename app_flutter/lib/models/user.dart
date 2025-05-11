import 'package:flutter/material.dart'; 

class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

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
