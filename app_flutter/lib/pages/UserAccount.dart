import 'package:app_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_flutter/database/userDao.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final _formKey = GlobalKey<FormState>(); // Para validar os campos

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  Future<void> recuperarUsuarioDoStorage() async {
    const secureStorage = FlutterSecureStorage();

    final nome = await secureStorage.read(key: 'nome');
    final email = await secureStorage.read(key: 'email');

    if (nome != null && email != null) {
      setState(() {
        _name = nome;
        _email = email;
      });
    }
  }

  Future<void> atualizarUsuario() async {
    const secureStorage = FlutterSecureStorage();

    // Recupera o ID do usuário no secure storage
    final idString = await secureStorage.read(key: 'id');

    if (idString != null) {
      final userId = int.tryParse(idString);

      if (userId != null) {
        await SQLHelper.updateUser(userId, _name, _email, _password);

        // Atualiza os dados no Secure Storage
        await secureStorage.write(key: 'nome', value: _name);
        await secureStorage.write(key: 'email', value: _email);
      } else {
        debugPrint('ID do usuário inválido no storage');
      }
    } else {
      debugPrint('ID do usuário não encontrado no storage');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        title: const Text('Minha Conta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: "Nome",
                initialValue: _name,
                onChanged: (value) => _name = value,
              ),
              buildTextField(
                label: "E-mail",
                initialValue: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _email = value,
              ),
              buildTextField(
                label: "Senha",
                obscureText: true,
                onChanged: (value) => _password = value,
              ),
              buildTextField(
                label: "Confirmar Senha",
                obscureText: true,
                onChanged: (value) => _confirmPassword = value,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: async() {
                    if (_formKey.currentState!.validate()) {
                      await atualizarUsuario()
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    recuperarUsuarioDoStorage();
  }
}
