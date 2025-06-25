import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen>{

  double _speed = 1.0;
  String _selectedVoice = 'Maria';
  int _fontSize = 12;

  final _secureStorage = const FlutterSecureStorage();

  Future<void> carregarConfiguracoes() async {
    final speed = await _secureStorage.read(key: 'config_speed');
    final voice = await _secureStorage.read(key: 'config_voice');
    final fontSize = await _secureStorage.read(key: 'config_fontSize');

    setState(() {
      _speed = double.tryParse(speed ?? '1.0') ?? 1.0;
      _selectedVoice = voice ?? 'Maria';
      _fontSize = int.tryParse(fontSize ?? '12') ?? 12;
    });
  }

  Future<void> salvarConfiguracoes() async {
    await _secureStorage.write(key: 'config_speed', value: _speed.toString());
    await _secureStorage.write(key: 'config_voice', value: _selectedVoice);
    await _secureStorage.write(key: 'config_fontSize', value: _fontSize.toString());
  }

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Home() )
                );
          },
        ),
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.settings,
                size: 80,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            buildDropdown<double>(
              label: "Velocidade",
              value: _speed,
              items: [0.5, 1.0, 1.5, 2.0],
              onChanged: (value) {
                setState(() {
                  _speed = value!;
                });
              },
            ),
            buildDropdown<String>(
              label: "Voz padrão",
              value: _selectedVoice,
              items: ["Maria", "João", "Ana", "Carlos"],
              onChanged: (value) {
                setState(() {
                  _selectedVoice = value!;
                });
              },
            ),
            buildDropdown<int>(
              label: "Tam. Fonte",
              value: _fontSize,
              items: [10, 12, 14, 16, 18],
              onChanged: (value) {
                setState(() {
                  _fontSize = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                  onPressed: () async {
                    await salvarConfiguracoes();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configurações salvas com sucesso!')),
                    );
                  },
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
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
          DropdownButtonFormField<T>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}



