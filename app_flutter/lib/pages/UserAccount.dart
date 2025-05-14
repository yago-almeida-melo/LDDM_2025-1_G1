import 'package:app_flutter/models/user.dart';
import 'package:app_flutter/database/userDao.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Usaremos ambos os métodos de armazenamento para garantir
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = true;
  bool _isSaving = false;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _currentPassword = '';

  // Método para recuperar dados do usuário usando ambos os métodos de armazenamento
  Future<void> recuperarUsuarioDoStorage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Primeiro tentamos do FlutterSecureStorage
      String? nome = await _secureStorage.read(key: 'nome');
      String? email = await _secureStorage.read(key: 'email');
      String? senha = await _secureStorage.read(key: 'senha');

      // Se não encontrarmos, tentamos do SharedPreferences
      if (nome == null || email == null) {
        final prefs = await SharedPreferences.getInstance();
        nome = prefs.getString('nome');
        email = prefs.getString('email');
        senha = prefs.getString('senha');
      }

      if (nome != null && email != null) {
        setState(() {
          _name = nome!;
          _email = email!;
          _currentPassword = senha ?? '';
        });
        print('Dados carregados: Nome=$_name, Email=$_email, Senha=${senha != null ? "***" : "não definida"}');
      } else {
        print('Nenhum dado encontrado no storage');
      }
    } catch (e) {
      print('Erro ao recuperar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para salvar em ambos os armazenamentos
  Future<void> salvarDados() async {
    if (_formKey.currentState!.validate()) {
      // Verificar se as senhas coincidem quando uma nova senha é informada
      if (_password.isNotEmpty && _password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem!')),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {

        // Salvar a senha apenas se uma nova senha foi informada
        if (_password.isNotEmpty) {
          SQLHelper.updateUser(_name, _email, _password);

          // Atualizar a senha atual na memória
          setState(() {
            _currentPassword = _password;
            _password = '';
            _confirmPassword = '';
          });

          print('Nova senha definida e salva');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados salvos com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Erro ao salvar dados: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // Função para limpar todos os dados (para teste)
  Future<void> _limparDados() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Limpar FlutterSecureStorage
      await _secureStorage.deleteAll();

      // Limpar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      setState(() {
        _name = '';
        _email = '';
        _password = '';
        _confirmPassword = '';
        _currentPassword = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todos os dados foram limpos!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      print('Erro ao limpar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para exibir os dados armazenados (para debug)
  Future<void> _mostrarDadosArmazenados() async {
    // Verificar dados no FlutterSecureStorage
    final nome = await _secureStorage.read(key: 'nome');
    final email = await _secureStorage.read(key: 'email');
    final senha = await _secureStorage.read(key: 'senha');

    // Verificar dados no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final nomePrefs = prefs.getString('nome');
    final emailPrefs = prefs.getString('email');
    final senhaPrefs = prefs.getString('senha');

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
        actions: [
          // Botão para debug (verificar dados no storage)
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _mostrarDadosArmazenados,
            tooltip: 'Verificar dados salvos',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
                label: "Nova Senha (deixe em branco para não alterar)",
                obscureText: true,
                initialValue: _password,
                onChanged: (value) => _password = value,
                validator: (value) {
                  // Senha é opcional se estiver vazia
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              buildTextField(
                label: "Confirmar Nova Senha",
                obscureText: true,
                initialValue: _confirmPassword,
                onChanged: (value) => _confirmPassword = value,
                validator: (value) {
                  if (_password.isNotEmpty && (value == null || value.isEmpty)) {
                    return 'Por favor, confirme sua nova senha';
                  }
                  if (_password.isNotEmpty && value != _password) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              if (_currentPassword.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Senha atual definida: ${_currentPassword.replaceAll(RegExp(r'.'), '*')}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
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
                  onPressed: _isSaving ? null : salvarDados,
                  child: _isSaving
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Salvando..."),
                    ],
                  )
                      : const Text("Salvar"),
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
    String? Function(String?)? validator,
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
            validator: validator ?? (value) {
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