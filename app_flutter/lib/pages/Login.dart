import 'package:app_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Register.dart';
import '/pages/Home.dart';
import '../database/userDao.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> salvarUsuarioNoStorage(User usuario) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'id', value: usuario.id.toString());
    await secureStorage.write(key: 'nome', value: usuario.nome);
    await secureStorage.write(key: 'email', value: usuario.email);
  }

  Future<void> validUser() async {
    String email = _emailController.text;
    String senha = _passwordController.text;

    List<Map<String, dynamic>> user = await Userdao.getUser(email);

    if (user[0].isNotEmpty) {
      if (user[0]['senha'] == senha) {

        //Armazenar usuário no local Storage
        final usuario = User.fromJson(user[0]);
        await salvarUsuarioNoStorage(usuario);

        // Navegar para a página Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        _showErrorDialog("Senha incorreta");
      }
    } else {
      _showErrorDialog("Usuário não encontrado");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo ou título
              const Icon(Icons.visibility, size: 150, color: Colors.teal),
              const Text(
                'Visia',
                style: TextStyle(color: Colors.teal, fontSize: 50),
              ),
              const SizedBox(height: 30),

              // Campo de Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // Campo de Senha
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: _obscureText,
              ),

              // Link de Recuperação de Senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Lógica de recuperação de senha
                  },
                  child: const Text('Esqueceu a senha?'),
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white, // Cor do texto e ícones
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () async {
                    await validUser();
                  }),

              const SizedBox(height: 50),

              // Botões de login social
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Google
                  _buildSocialButton(
                    icon: Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      // Lógica de login com Google
                    },
                  ),

                  const SizedBox(width: 16),

                  // Botão Apple
                  _buildSocialButton(
                    icon:
                        const Icon(Icons.apple, color: Colors.white, size: 24),
                    onPressed: () {
                      // Lógica de login com Apple
                    },
                  ),

                  const SizedBox(width: 16),

                  // Botão Facebook
                  _buildSocialButton(
                    icon: const Icon(Icons.facebook,
                        color: Colors.white, size: 24),
                    onPressed: () {
                      // Lógica de login com Facebook
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Link de Registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta? ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegação para tela de registro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                    child: const Text(
                      'Registre-se',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(70, 50),
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: icon,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
