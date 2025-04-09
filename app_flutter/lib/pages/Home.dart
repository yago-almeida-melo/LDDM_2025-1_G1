import 'package:curved_nav_bar/curved_bar/curved_action_bar.dart';
import 'package:curved_nav_bar/fab_bar/fab_bottom_app_bar_item.dart';
import 'package:curved_nav_bar/flutter_curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/pages/Config.dart';

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
              child: Icon(
                Icons.flutter_dash, // Ícone de logo
                color: Colors.white,
                size: 30,
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
                  print('Perfil do usuário');
                },
              ),
            ],
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
