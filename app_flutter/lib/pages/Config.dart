import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Home.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen>{

  double _speed = 1.0;
  String _selectedVoice = 'Maria';
  int _fontSize = 12;

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
                    builder: (context) => Home() )
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
            Center(
              child: Icon(
                Icons.settings,
                size: 80,
                color: Colors.blue,
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
                onPressed: () {},
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
