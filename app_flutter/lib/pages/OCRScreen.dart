import 'package:app_flutter/database/medicamentoDao.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_flutter/pages/Home.dart';
import 'package:app_flutter/pages/Details.dart';
import 'package:app_flutter/providers/bula_provider.dart';
import 'package:app_flutter/models/medicamento_model.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});
  // Lista fictícia de remédios para simular o armazenamento
  static List<Map<String, dynamic>> listaRemedios = [];
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  String _textoExtraido = '';
  String _nomeMedicamento = '';
  String _informacoesSimplificadas = '';
  bool _processando = false;
  bool _medicamentoDetectado = false;
  File? _imagemCapturada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificar Remédio'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Área de instrução
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal[200]!),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 48,
                    color: Colors.teal,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Fotografe a caixa do remédio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Posicione a caixa bem iluminada e com o nome do medicamento visível',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botões de captura
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _processando
                        ? null
                        : () => _capturarImagem(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _processando
                        ? null
                        : () => _capturarImagem(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeria'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Indicador de processamento
            if (_processando)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: const Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Processando imagem...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Identificando texto e simplificando informações',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            // Imagem capturada
            if (_imagemCapturada != null && !_processando)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imagemCapturada!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Resultado do processamento
            if (_medicamentoDetectado && !_processando) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Medicamento Identificado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nome: $_nomeMedicamento',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Informações Simplificadas:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _informacoesSimplificadas,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _adicionarALista,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar à Lista'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _verDetalhes,
                      icon: const Icon(Icons.info),
                      label: const Text('Ver Detalhes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Texto extraído (para debug)
            if (_textoExtraido.isNotEmpty && !_processando)
              ExpansionTile(
                title: const Text('Texto Extraído (Debug)'),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _textoExtraido,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _capturarImagem(ImageSource source) async {
    try {
      setState(() {
        _processando = true;
        _medicamentoDetectado = false;
        _textoExtraido = '';
        _nomeMedicamento = '';
        _informacoesSimplificadas = '';
      });

      final picker = ImagePicker();
      final XFile? imagemSelecionada = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (imagemSelecionada != null) {
        setState(() {
          _imagemCapturada = File(imagemSelecionada.path);
        });

        await _processarImagem(File(imagemSelecionada.path));
      }
    } catch (e) {
      _mostrarErro('Erro ao capturar imagem: $e');
    } finally {
      setState(() {
        _processando = false;
      });
    }
  }

  Future<void> _processarImagem(File imagem) async {
    try {
      // 1. Extrair texto da imagem usando OCR
      final inputImage = InputImage.fromFile(imagem);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      setState(() {
        _textoExtraido = recognizedText.text;
      });

      // 2. Identificar nome do medicamento
      final nomeDetectado = _extrairNomeMedicamento(_textoExtraido);

      if (nomeDetectado != null) {
        setState(() {
          _nomeMedicamento = nomeDetectado;
        });

        // 3. Simplificar informações usando IA simulada
        await _simplificarInformacoes(_textoExtraido, nomeDetectado);

        setState(() {
          _medicamentoDetectado = true;
        });
      } else {
        _mostrarErro(
            'Não foi possível identificar o nome do medicamento. Tente uma imagem mais clara.');
      }

      await textRecognizer.close();
    } catch (e) {
      _mostrarErro('Erro ao processar imagem: $e');
    }
  }

  String? _extrairNomeMedicamento(String texto) {
    final linhas = texto.split('\n');

    // Procurar por palavras em maiúsculas que podem ser o nome do medicamento
    for (var linha in linhas) {
      final linhaTrimmed = linha.trim();
      if (linhaTrimmed.length < 3) continue;

      // Verificar se a linha contém palavras em maiúsculas
      final palavras = linhaTrimmed.split(RegExp(r'\s+'));
      for (var palavra in palavras) {
        // Remover caracteres especiais
        final palavraLimpa = palavra.replaceAll(RegExp(r'[^\w\s]'), '');

        // Verificar se é uma palavra significativa em maiúsculas
        if (palavraLimpa.length > 3 &&
            palavraLimpa == palavraLimpa.toUpperCase() &&
            palavraLimpa.contains(RegExp(r'[A-Z]'))) {
          return palavraLimpa;
        }
      }
    }

    // Se não encontrar em maiúsculas, tentar outras estratégias
    for (var linha in linhas) {
      final linhaTrimmed = linha.trim();
      if (linhaTrimmed.length > 5 && linhaTrimmed.length < 30) {
        // Verificar se parece com nome de medicamento
        if (RegExp(r'^[A-Za-z\s]+$').hasMatch(linhaTrimmed)) {
          return linhaTrimmed.toUpperCase();
        }
      }
    }

    return null;
  }

  Future<void> _simplificarInformacoes(
      String textoCompleto, String nomeMedicamento) async {
    // Simulação de processamento com IA
    // Em um app real, você faria uma chamada para uma API de IA como OpenAI, Google AI, etc.
    final BulaProvider _bulaProvider = BulaProvider();

    await Future.delayed(
        const Duration(seconds: 2)); // Simular tempo de processamento

    // Informações simuladas baseadas no nome do medicamento
    final informacoesSimuladas =
        await _bulaProvider.buscarInfoRemedio(textoCompleto);

    setState(() {
      _informacoesSimplificadas = informacoesSimuladas.toString();
    });
  }

  // String _gerarInformacoesSimuladas(String nomeMedicamento) {
  //   // Simulação simples de informações baseadas no nome
  //   // Em um app real, isso seria processado por IA

  //   final informacoes = [
  //     "Para que serve: Tratamento de dor e inflamação.",
  //     "Como usar: Tomar 1 comprimido a cada 8 horas, preferencialmente com alimentos.",
  //     "Cuidados: Não exceder a dose recomendada. Consulte um médico se os sintomas persistirem.",
  //     "Contraindicações: Não usar em caso de alergia aos componentes da fórmula.",
  //     "Efeitos colaterais: Podem ocorrer náuseas, tontura ou sonolência em alguns casos."
  //   ];

  //   return informacoes.join('\n\n');
  // }

Future<void> _adicionarALista() async {
  try {
    await MedicamentoDAO.insertMedicamento(
      _nomeMedicamento,
      _informacoesSimplificadas,
      _textoExtraido,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_nomeMedicamento adicionado com sucesso ao histórico!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Ver Lista',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao salvar no banco: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  void _verDetalhes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          indiceRemedio: listaRemedios.length,
          nomeRemedio: _nomeMedicamento,
          textoCompletoBula: _textoExtraido,
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Método estático para acessar a lista de remédios de outras telas
  static List<Map<String, dynamic>> get listaRemedios => listaRemedios;
}
