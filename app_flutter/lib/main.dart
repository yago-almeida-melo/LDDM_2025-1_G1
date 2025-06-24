import 'package:flutter/material.dart';

// --- IMPORTS QUE ESTAVAM A FALTAR E CORRIGEM OS ERROS ---
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Suas importações de páginas
import 'pages/Login.dart';
import 'pages/Home.dart';

Future<void> main() async {
  // Garante que os bindings do Flutter foram inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega as variáveis de ambiente do seu ficheiro .env
  await dotenv.load(fileName: ".env");

  // Lógica para o SQFlite funcionar em desktop (Windows, etc.)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Inicia a sua aplicação
  runApp(const MyApp());
}

/// Este é o widget raiz da sua aplicação.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visia',
      debugShowCheckedModeBanner: false, // Opcional: para remover o banner de debug
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: const LoginScreen(),
    );
  }
}