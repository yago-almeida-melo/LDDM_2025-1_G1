import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/bula_provider.dart';

class DetailsScreen extends StatefulWidget {
  final String nomeRemedio;
  final String textoCompletoBula;

  const DetailsScreen({
    super.key,
    required this.nomeRemedio,
    required this.textoCompletoBula,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final BulaProvider _bulaProvider = BulaProvider();

  bool _isLoading = true;
  String? _bulaSimplificada;
  String? _errorMessage;
  bool isPlaying = false;
  double speechRate = 1.0;
  double pitch = 1.0;
  double volume = 1.0;

  @override
  void initState() {
    super.initState();
    _simplificarBulaRecebida();
    _setupTts();
  }

  Future<void> _simplificarBulaRecebida() async {
    setState(() => _isLoading = true);
    try {
      final resultado = await _bulaProvider.simplificarBula(widget.textoCompletoBula);
      setState(() => _bulaSimplificada = resultado);
    } catch (e) {
      setState(() => _errorMessage = "Erro ao simplificar a bula.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage("pt-BR");
    flutterTts.setStartHandler(() => setState(() => isPlaying = true));
    flutterTts.setCompletionHandler(() => setState(() => isPlaying = false));
    flutterTts.setErrorHandler((_) => setState(() => isPlaying = false));
    await _applyTtsSettings();
  }

  Future<void> _applyTtsSettings() async {
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
  }

  Future<void> _speakText() async {
    if (isPlaying) {
      await flutterTts.stop();
    } else {
      if (_bulaSimplificada != null && _bulaSimplificada!.isNotEmpty) {
        await flutterTts.speak(_bulaSimplificada!);
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: Text(widget.nomeRemedio, style: const TextStyle(color: Colors.white, fontSize: 30)),
      ),
      body: Center(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Simplificando a bula com IA..."),
        ],
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 18), textAlign: TextAlign.center),
      );
    }

    if (_bulaSimplificada != null) {
      return Markdown(
        data: _bulaSimplificada!,
        padding: const EdgeInsets.all(16.0),
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(fontSize: 18, height: 1.5),
          h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      );
    }

    return const Text("Nenhuma informação disponível.");
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.teal,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.replay_10, color: Colors.white, size: 50),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50),
            onPressed: _bulaSimplificada != null ? _speakText : null,
          ),
          IconButton(
            icon: const Icon(Icons.forward_10, color: Colors.white, size: 50),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 50),
            onPressed: () => _showTtsSettings(context),
          ),
        ],
      ),
    );
  }

  void _showTtsSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Configurações de áudio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildSliderRow('Velocidade:', speechRate, 0.5, 2.0, (val) => setModalState(() => speechRate = val)),
                  _buildSliderRow('Tom:', pitch, 0.5, 2.0, (val) => setModalState(() => pitch = val)),
                  _buildSliderRow('Volume:', volume, 0.0, 1.0, (val) => setModalState(() => volume = val)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () async {
                      await _applyTtsSettings();
                      Navigator.pop(context);
                    },
                    child: const Text("Aplicar", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Expanded(
          child: Slider(
            activeColor: Colors.teal,
            value: value,
            min: min,
            max: max,
            divisions: (max == 1.0) ? 10 : 15,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
