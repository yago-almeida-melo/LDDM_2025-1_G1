import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Config.dart';
import 'package:app_flutter/pages/UserAccount.dart';

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
          print(value);
        },
        activeIcon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(
            Icons.camera_alt,
            size: 50,
            color: Colors.teal,
          ),
        ),
        inActiveIcon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
          child: Icon(
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
          activeIcon: Icon(Icons.home, color: Colors.white),
          inActiveIcon: Icon(Icons.home, color: Colors.black26),
          text: 'Início',
        ),
        FABBottomAppBarItem(
          activeIcon: Icon(Icons.settings, color: Colors.white),
          inActiveIcon: Icon(Icons.settings, color: Colors.black26),
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
                child: Icon(
                  Icons.info, // Ícone de logo como botão
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
                  Icons.account_circle, // Ícone de perfil
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => UserAccountScreen())
                  );
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
              : ListView(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 150.0),
            children: List.generate(
              7, // num de elementos
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                  decoration: BoxDecoration(
                    color: Colors.teal[200],
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
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[400],
                          size: 60,
                        ),
                      ),
                      SizedBox(width: 5), // Distancia texto e imagem
                      Text(
                        'Nome do Remédio',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Config screen content
        ConfigScreen()
      ],
      actionBarView: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.orange,
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
                  icon: Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
                SizedBox(width: 20),
                Text(
                  'Sobre o Aplicativo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
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
                    description: 'Reconhecimento preciso de texto em materiais impressos.',
                  ),
                  FeatureItem(
                    icon: Icons.record_voice_over,
                    title: 'Ler em Voz Alta',
                    description: 'Conversão de texto para áudio com vozes naturais.',
                  ),
                  FeatureItem(
                    icon: Icons.format_size,
                    title: 'Aumentar Tamanho da Letra',
                    description: 'Ajuste do tamanho do texto para melhor visualização.',
                  ),
                  FeatureItem(
                    icon: Icons.speed,
                    title: 'Ajustar Velocidade da Narração',
                    description: 'Controle da velocidade de leitura do texto.',
                  ),
                  FeatureItem(
                    icon: Icons.mic,
                    title: 'Navegação por Comando de Voz',
                    description: 'Interface acessível controlada por comandos de voz.',
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
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.teal,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
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