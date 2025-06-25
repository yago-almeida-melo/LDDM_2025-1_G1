import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Details.dart';
import 'package:app_flutter/pages/Config.dart';
import 'package:app_flutter/pages/UserAccount.dart';
import 'package:app_flutter/pages/QrCodeReader.dart';
import 'package:app_flutter/pages/OCRScreen.dart';

class RemedioEstatico {
  final String nome;
  final String bulaCompleta;
  final IconData icone;

  RemedioEstatico({
    required this.nome,
    required this.bulaCompleta,
    this.icone = Icons.medication_liquid,
  });
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool _showAboutScreen = false;

  final List<RemedioEstatico> listaDeRemedios = [
    RemedioEstatico(
      nome: "Dipirona",
      bulaCompleta: """
        INDICAÇÕES: Este medicamento é indicado como analgésico (para dor) e antitérmico (para febre).
        CONTRAINDICAÇÕES: Não deve ser utilizada caso você tenha: alergia ou intolerância à dipirona ou a qualquer um dos componentes da formulação; funções da medula óssea prejudicadas ou doenças do sistema hematopoiético; desenvolvido broncoespasmo ou outras reações anafilactoides, como urticária, rinite, angioedema com uso de medicamentos para dor; porfiria hepática aguda intermitente; deficiência congênita da glicose-6-fosfato-desidrogenase. Este medicamento é contraindicado para menores de 3 meses de idade ou pesando menos de 5 kg.
        POSOLOGIA E MODO DE USAR: Adultos e adolescentes acima de 15 anos: 1 a 2 comprimidos até 4 vezes ao dia. Crianças: o uso deve ser conforme orientação médica. Não exceder a dose máxima diária.
        REAÇÕES ADVERSAS: Em casos raros, pode ocorrer choque anafilático. As reações cutâneas mais comuns são erupções e urticária. Síndrome de Stevens-Johnson e Necrólise Epidérmica Tóxica podem ocorrer. Reações hematológicas como agranulocitose são raras mas graves, exigindo descontinuação imediata. Em caso de superdose, procurar socorro médico imediatamente.
      """,
    ),
    RemedioEstatico(
      nome: "Paracetamol",
      bulaCompleta: """
        INDICAÇÕES: Paracetamol é indicado para o alívio temporário de dores leves a moderadas associadas a gripes e resfriados comuns, dor de cabeça, dor de dente, dor nas costas, dores musculares, cólicas menstruais e para a redução da febre.
        CONTRAINDICAÇÕES: Este produto não deve ser administrado a pacientes com hipersensibilidade ao paracetamol ou a qualquer outro componente de sua fórmula. Não use outro produto que contenha paracetamol. Risco de dano hepático.
        POSOLOGIA E MODO DE USAR: Adultos e crianças acima de 12 anos: 1 comprimido de 750 mg a cada 6-8 horas, não excedendo 4 comprimidos em um período de 24 horas. O tratamento não deve durar mais de 3 dias para febre e 7 dias para dor.
        REAÇÕES ADVERSAS: Reações de hipersensibilidade como erupção cutânea, urticária e angioedema são raras. Em doses excessivas, pode causar hepatotoxicidade grave, que pode ser fatal. Outros efeitos incluem náuseas, vômitos e dor abdominal.
      """,
    ),
    RemedioEstatico(
      nome: "Amoxicilina",
      bulaCompleta: """
        INDICAÇÕES: Amoxicilina, um antibiótico, é usado no tratamento de infecções bacterianas causadas por microrganismos sensíveis à amoxicilina, como infecções do trato respiratório (sinusite, otite média, faringite, pneumonia), infecções do trato urinário, infecções de pele e tecidos moles.
        CONTRAINDICAÇÕES: É contraindicado para pacientes com histórico de reação alérgica a qualquer penicilina ou a qualquer componente da formulação. Pacientes com mononucleose infecciosa têm alto risco de desenvolver erupção cutânea.
        POSOLOGIA E MODO DE USAR: A dose usual para adultos é de 500 mg a cada 8 horas ou 875 mg a cada 12 horas. A duração do tratamento depende do tipo e da gravidade da infecção e deve ser determinada pelo médico. Complete todo o ciclo de tratamento, mesmo que se sinta melhor.
        REAÇÕES ADVERSAS: As reações mais comuns são diarreia, náusea e erupções cutâneas. Reações alérgicas graves, incluindo anafilaxia, podem ocorrer. Superinfecção, como candidíase, pode ocorrer com o uso prolongado.
      """,
    ),
    RemedioEstatico(
      nome: "Ibuprofeno",
      bulaCompleta: """
        INDICAÇÕES: Ibuprofeno é um anti-inflamatório não esteroide (AINE) com atividade analgésica e antipirética, indicado para o alívio de dores de cabeça, dor de dente, dores musculares, cólicas menstruais, e para o tratamento de febre e sintomas de gripes e resfriados.
        CONTRAINDICAÇÕES: Hipersensibilidade ao ibuprofeno, a qualquer componente da fórmula ou a outros AINEs. Pacientes com histórico de asma, urticária ou reações alérgicas após tomar aspirina ou outros AINEs. Pacientes com úlcera péptica ativa ou histórico de sangramento gastrointestinal.
        POSOLOGIA E MODO DE USAR: Adultos: 400 mg a cada 6 a 8 horas. A dose máxima diária não deve exceder 2400 mg. Para dor leve, 200 mg pode ser suficiente. Tomar com alimentos para reduzir o desconforto gástrico.
        REAÇÕES ADVERSAS: Os efeitos mais comuns são gastrointestinais, como dispepsia, náuseas, vômitos, dor abdominal e diarreia. Pode aumentar o risco de eventos cardiovasculares trombóticos, como infarto do miocárdio e acidente vascular cerebral. Risco de insuficiência renal.
      """,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
        onTab: (value) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OCRScreen()));
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
              ? AboutScreen(
                  onBack: () => setState(() => _showAboutScreen = false))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 150.0),
                  itemCount: listaDeRemedios.length,
                  itemBuilder: (context, index) {
                    final remedio = listaDeRemedios[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                nomeRemedio: remedio.nome,
                                textoCompletoBula: remedio.bulaCompleta,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
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
                                  remedio.icone,
                                  color: Colors.grey[400],
                                  size: 60,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  remedio.nome,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const ConfigScreen()
      ],
      actionBarView: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
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
