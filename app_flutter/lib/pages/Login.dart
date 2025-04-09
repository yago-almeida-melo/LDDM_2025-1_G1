import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Register.dart';
import '/pages/Home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

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
              const Icon(Icons.visibility, size: 150, color: Colors.indigoAccent),
              const Text('Visia', style: TextStyle(color: Colors.indigoAccent,fontSize: 50),),
              const SizedBox(height: 30),

              // Campo de Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
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
                  prefixIcon: Icon(Icons.lock),
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
                  child: Text('Esqueceu a senha?'),
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black, // Cor do texto e ícones
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  // Lógica de login
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home()
                    ),
                  );
                },
              ),

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
                    icon: Icon(Icons.apple, color: Colors.white, size: 24),
                    onPressed: () {
                      // Lógica de login com Apple
                    },
                  ),

                  const SizedBox(width: 16),

                  // Botão Facebook
                  _buildSocialButton(
                    icon: Icon(Icons.facebook, color: Colors.white, size: 24),
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
                            builder: (context) => Register()
                        ),
                      );
                    },
                    child: const Text(
                      'Registre-se',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
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