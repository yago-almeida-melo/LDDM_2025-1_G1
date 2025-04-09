import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Home.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final _formKey = GlobalKey<FormState>(); // Para validar os campos

  String _name = 'André';
  String _email = 'andre@gmail.com';
  String _password = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home())
            );
          },
        ),
        title: const Text('Minha Conta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
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
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Salvar as informações
                      print("Nome: $_name, Email: $_email, Senha: $_password");
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
}
