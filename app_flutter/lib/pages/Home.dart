import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Details.dart';
import 'package:app_flutter/pages/Config.dart';
import 'package:app_flutter/pages/UserAccount.dart';
import 'package:app_flutter/pages/QrCodeReader.dart';
import 'package:app_flutter/pages/OCRScreen.dart'; // Nova importação

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool _showAboutScreen = false;

  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
        onTab: (value) {
          // Navegação atualizada para a nova tela de OCR
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OCRScreen()));
        },
        activeIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(
            Icons.camera_alt,
            size: 50,
            color: Colors.teal,
          ),
        ),
        inActiveIcon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.white70, shape: BoxShape.circle),
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 50,
            color: Colors.teal,
          ),
        ),
        text: "Câmera",
      ),
      activeColor: Colors.white,
      navBarBackgroundColor: Colors.teal,
      inActiveColor: Colors.black45,
      appBarItems: [
        FABBottomAppBarItem(
          activeIcon: const Icon(Icons.home, color: Colors.white),
          inActiveIcon: const Icon(Icons.home, color: Colors.black26),
          text: 'Início',
        ),
        FABBottomAppBarItem(
          activeIcon: const Icon(Icons.settings, color: Colors.white),
          inActiveIcon: const Icon(Icons.settings, color: Colors.black26),
          text: 'Configurações',
        ),
      ],
      bodyItems: [
        // Home screen content
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showAboutScreen = true;
                  });
                },
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            title: const Text(
              'Visia',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRCodeScannerSecreen()));
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserAccountScreen()));
                },
              ),
            ],
          ),
          body: _showAboutScreen
              ? AboutScreen(onBack: () {
                  setState(() {
                    _showAboutScreen = false;
                  });
                })
              : _buildHomeContent(),
        ),
        // Config screen content
        const ConfigScreen()
      ],
      actionBarView: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.orange,
      ),
    );
  }

  Widget _buildHomeContent() {
    // Combinar remédios padrão com os identificados via OCR
    final remediosOCR = OCRScreen.listaRemedios;
    final totalRemedios = 7 + remediosOCR.length; // 7 remédios padrão + OCR

    if (totalRemedios == 0) {
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 150.0),
      children: [
        // Header da lista
        if (remediosOCR.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remédios Identificados',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      Text(
                        '${remediosOCR.length} medicamento(s) adicionado(s) via câmera',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Lista de remédios
        ...List.generate(totalRemedios, (index) {
          final isOCRItem = index < remediosOCR.length;
          final remedioOCR = isOCRItem ? remediosOCR[index] : null;
          final nomeRemedio = isOCRItem
              ? remedioOCR!['nome']
              : 'Remédio ${index - remediosOCR.length + 1}';

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      indiceRemedio: index,
                      nomeRemedio: nomeRemedio,
                      textoCompletoBula: "",
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                decoration: BoxDecoration(
                  color: isOCRItem ? Colors.blue[200] : Colors.teal[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              isOCRItem ? Icons.camera_alt : Icons.image,
                              color: Colors.grey[400],
                              size: 60,
                            ),
                          ),
                          if (isOCRItem)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeRemedio,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isOCRItem) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Identificado via OCR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        // Botão para adicionar novo remédio
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OCRScreen()),
              );
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Identificar Novo Remédio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhum remédio identificado',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Use a câmera para identificar e adicionar medicamentos à sua lista',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OCRScreen()),
              );
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Identificar Remédio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AboutScreen({required this.onBack, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
                const SizedBox(width: 20),
                const Text(
                  'Sobre o Aplicativo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.visibility,
                      size: 80,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Visia',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nosso aplicativo móvel foi desenvolvido para auxiliar pessoas com deficiência visual, dislexia e analfabetismo, proporcionando uma experiência de leitura inovadora e acessível. Utilizamos tecnologia avançada de reconhecimento óptico de caracteres (OCR) para captar texto a partir de imagens e convertê-lo em áudio por meio de síntese de fala (TTS). Isso permite que os usuários acessem livros, documentos e outros materiais impressos de forma intuitiva e eficiente, eliminando a barreira da leitura tradicional. Com alta precisão na identificação de textos presentes em fotos de documentos, embalagens, livros e panfletos, nosso app transforma a informação em voz, ampliando a autonomia e a inclusão para pessoas de todas as idades e demografias.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Principais Funcionalidades',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  FeatureItem(
                    icon: Icons.text_fields,
                    title: 'Identificar Letra',
                    description:
                    'Reconhecimento preciso de texto em materiais impressos.',
                  ),
                  FeatureItem(
                    icon: Icons.record_voice_over,
                    title: 'Ler em Voz Alta',
                    description:
                    'Conversão de texto para áudio com vozes naturais.',
                  ),
                  FeatureItem(
                    icon: Icons.format_size,
                    title: 'Aumentar Tamanho da Letra',
                    description:
                    'Ajuste do tamanho do texto para melhor visualização.',
                  ),
                  FeatureItem(
                    icon: Icons.speed,
                    title: 'Ajustar Velocidade da Narração',
                    description: 'Controle da velocidade de leitura do texto.',
                  ),
                  FeatureItem(
                    icon: Icons.mic,
                    title: 'Navegação por Comando de Voz',
                    description:
                    'Interface acessível controlada por comandos de voz.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Versão 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '© 2025 Visia Team. Todos os direitos reservados.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

