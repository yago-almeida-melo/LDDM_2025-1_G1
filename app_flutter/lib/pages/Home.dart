import 'package:flutter/material.dart';
import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavBar(
      actionButton: CurvedActionBar(
          onTab: (value) {
            /// perform action here
            print(value);
          },
          activeIcon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            ),
            child: Icon(
              Icons.camera_alt,
              size: 50,
              color: Colors.teal,
            ),
          ),
          inActiveIcon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 50,
              color: Colors.teal,
            ),
          ),
          text: "Câmera"
      ),
      activeColor: Colors.white,
      navBarBackgroundColor: Colors.teal,
      inActiveColor: Colors.black45,
      appBarItems: [
        FABBottomAppBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            inActiveIcon: Icon(
              Icons.home,
              color: Colors.black26,
            ),
            text: 'Início'
        ),
        FABBottomAppBarItem(
            activeIcon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            inActiveIcon: Icon(
              Icons.settings,
              color: Colors.black26,
            ),
            text: 'Configurações'
        ),
      ],
      bodyItems: [
        // Home screen content
        Scaffold(
          appBar: AppBar(
            title: const Text(
                'Visia',
                style: TextStyle(
                    color: Colors.white
                )
            ),
            centerTitle: true,
            backgroundColor: Colors.teal,

          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.tealAccent[100],
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.home,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Bem-vindo à Página Inicial',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Explore as funcionalidades do nosso aplicativo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Adicione a navegação para outra página
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => OutraPagina()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Começar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Wallet screen content
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.pinkAccent,
        )
      ],
      actionBarView: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.orange,
      ),
    );
  }
}