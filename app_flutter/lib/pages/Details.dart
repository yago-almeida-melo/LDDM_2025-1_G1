import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/bula_provider.dart';

// Enum para um controle de estado mais claro e robusto
enum TtsState { playing, paused, stopped }

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

  // Variáveis de estado para controlar a reprodução
  TtsState _ttsState = TtsState.stopped;
  int _currentWordOffset = 0; // Guarda a posição do texto ao pausar

  // Variáveis para os controles de áudio
  double speechRate = 1.0;
  double volume = 1.0;

  // Variáveis para controlar a visibilidade dos sliders
  bool _isVolumeSliderVisible = false;
  bool _isSpeedSliderVisible = false;

  @override
  void initState() {
    super.initState();
    _simplificarBulaRecebida();
    _setupTts();
  }

  Future<void> _simplificarBulaRecebida() async {
    setState(() => _isLoading = true);
    try {
      final resultado =
      await _bulaProvider.simplificarBula(widget.textoCompletoBula);
      setState(() => _bulaSimplificada = resultado);
    } catch (e) {
      setState(() => _errorMessage = "Erro ao simplificar a bula.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Configura os handlers do Text-to-Speech para atualizar o estado
  Future<void> _setupTts() async {
    await flutterTts.setLanguage("pt-BR");

    flutterTts.setStartHandler(() {
      setState(() {
        _ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        _ttsState = TtsState.stopped;
        _currentWordOffset = 0;
      });
    });

    flutterTts.setProgressHandler(
            (String text, int startOffset, int endOffset, String word) {
          _currentWordOffset = endOffset;
        });

    flutterTts.setErrorHandler((_) {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });

    await _applyTtsSettings();
  }

  Future<void> _applyTtsSettings() async {
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setVolume(volume);
  }

  // Lógica de play/pause/resume robusta
  Future<void> _speakText() async {
    if (_ttsState == TtsState.playing) {
      await flutterTts.stop();
      setState(() {
        _ttsState = TtsState.paused;
      });
    } else {
      if (_bulaSimplificada == null || _bulaSimplificada!.isEmpty) return;

      String textToSpeak;
      if (_currentWordOffset > 0 &&
          _currentWordOffset < _bulaSimplificada!.length) {
        textToSpeak = _bulaSimplificada!.substring(_currentWordOffset);
      } else {
        _currentWordOffset = 0;
        textToSpeak = _bulaSimplificada!;
      }

      await flutterTts.speak(textToSpeak);
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
        title: Text(widget.nomeRemedio,
            style: const TextStyle(color: Colors.white, fontSize: 30)),
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
        child: Text(_errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center),
      );
    }

    if (_bulaSimplificada != null) {
      // KEY CHANGE: SingleChildScrollView agora controla a rolagem corretamente
      return SingleChildScrollView(
        child: Padding( // Adicionado Padding aqui para o texto não colar nas bordas
          padding: const EdgeInsets.all(16.0),
          child: MarkdownBody( // Usar MarkdownBody é mais apropriado dentro de um ScrollView
            data: _bulaSimplificada!,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 18, height: 1.5),
              h2: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ),
        ),
      );
    }

    return const Text("Nenhuma informação disponível.");
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.teal,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Seção dos sliders (visível condicionalmente)
          if (_isVolumeSliderVisible) _buildVolumeSlider(),
          if (_isSpeedSliderVisible) _buildSpeedSlider(),

          // Seção dos botões
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    _isVolumeSliderVisible = !_isVolumeSliderVisible;
                    if (_isVolumeSliderVisible) {
                      _isSpeedSliderVisible = false; // Garante que só um slider apareça por vez
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                    _ttsState == TtsState.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 60),
                onPressed: _bulaSimplificada != null ? _speakText : null,
              ),
              IconButton(
                icon: const Icon(Icons.speed, color: Colors.white, size: 40),
                onPressed: () {
                  setState(() {
                    _isSpeedSliderVisible = !_isSpeedSliderVisible;
                    if (_isSpeedSliderVisible) {
                      _isVolumeSliderVisible = false; // Garante que só um slider apareça por vez
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para o slider de volume
  Widget _buildVolumeSlider() {
    return Slider(
      activeColor: Colors.white,
      inactiveColor: Colors.white.withOpacity(0.5),
      value: volume,
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: volume.toStringAsFixed(1),
      onChanged: (val) {
        setState(() => volume = val);
        _applyTtsSettings(); // Aplica a configuração em tempo real
      },
    );
  }

  // Widget para o slider de velocidade com indicador numérico
  Widget _buildSpeedSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // O slider ocupa a maior parte do espaço
        Expanded(
          child: Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.5),
            value: speechRate,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            label: speechRate.toStringAsFixed(1),
            onChanged: (val) {
              setState(() => speechRate = val);
              _applyTtsSettings(); // Aplica a configuração em tempo real
            },
          ),
        ),
        // Indicador numérico fixo ao lado do slider
        SizedBox(width: 8), // Pequeno espaçamento
        Text(
          speechRate.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
