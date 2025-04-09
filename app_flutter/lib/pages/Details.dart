import 'package:flutter/material.dart';
import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DetailsScreen extends StatefulWidget {
  final int indiceRemedio;
  final String nomeRemedio;

  const DetailsScreen({
    super.key,
    required this.indiceRemedio,
    required this.nomeRemedio
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final bottomNavBarPlayer = BottomNavBarPlayer();
  final FlutterTts flutterTts = FlutterTts();

  // Texto que será exibido e lido baseado no remédio selecionado
  late String textToRead;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Define o texto baseado nas informações do remédio
    textToRead = "Informações sobre ${widget.nomeRemedio}: Este remédio está na posição ${widget.indiceRemedio + 1} da lista. Aqui estão as instruções de uso...Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis elementum gravida nulla, vitae placerat leo viverra in. Nullam eu eleifend nunc. Vestibulum maximus condimentum sapien id pharetra. Nam at lectus vel libero dignissim scelerisque scelerisque sit amet odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac consectetur nunc. In tincidunt tortor magna, at condimentum metus molestie eget. Nulla consectetur justo ut neque condimentum auctor. Sed condimentum risus a leo luctus feugiat.";
    _setupTts();

    // Configurar os listeners para o estado do TTS
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speakText() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      await flutterTts.speak(textToRead);
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
        title: Text(style: const TextStyle(color: Colors.white, fontSize: 30), widget.nomeRemedio),
      ),
      bottomSheet: bottomNavBarPlayer.view(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exibe as informações do remédio
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                textToRead,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Botão para ler o texto
            /*MaterialButton(
              onPressed: _speakText,
              color: Colors.blue,
              child: Text(
                  isPlaying ? 'Parar áudio' : 'Ouvir informações',
                  style: const TextStyle(color: Colors.white)
              ),
            ),*/
            Expanded(child: Container()),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.teal,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_10, color: Colors.white, size: 50),
              onPressed: () async {
                // Implementação para voltar 10 segundos
                // Nota: O TTS não tem essa funcionalidade nativa, então esta é uma demonstração
                if (isPlaying) {
                  await flutterTts.stop();
                  await Future.delayed(const Duration(milliseconds: 300));
                  await flutterTts.speak(textToRead);
                }
              },
            ),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
              onPressed: _speakText,
            ),
            IconButton(
              icon: const Icon(Icons.forward_10, color: Colors.white, size: 50),
              onPressed: () {
                // Implementação para avançar 10 segundos
                // Nota: O TTS não tem essa funcionalidade nativa, então esta é uma demonstração
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 50),
              onPressed: () {
                // Mostrar opções de configuração do TTS
                _showTtsSettings(context);
              },
            ),
          ],
        ),
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
                  const Text(
                    'Configurações de áudio',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Controle de velocidade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Velocidade:'),
                      Slider(
                        activeColor: Colors.teal,
                        value: 1.0, // Valor inicial, você pode armazenar isso no estado
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: '1.5x',
                        onChanged: (value) async {
                          setModalState(() {});
                          await flutterTts.setSpeechRate(value);
                        },
                      ),
                    ],
                  ),
                  // Controle de tom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tom:'),
                      Slider(
                        activeColor: Colors.teal,
                        value: 1.0, // Valor inicial, você pode armazenar isso no estado
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: '1.0',
                        onChanged: (value) async {
                          setModalState(() {});
                          await flutterTts.setPitch(value);
                        },
                      ),
                    ],
                  ),
                  // Controle de volume
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Volume:'),
                      Slider(
                        activeColor: Colors.teal,
                        value: 1.0, // Valor inicial, você pode armazenar isso no estado
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '100%',
                        onChanged: (value) async {
                          setModalState(() {});
                          await flutterTts.setVolume(value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}