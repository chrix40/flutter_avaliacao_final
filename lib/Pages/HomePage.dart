import 'package:flutter/material.dart';
import 'package:flutter_avaliacao/Pages/Inicio.dart';
import 'package:flutter_avaliacao/Pages/Clima.dart';
import 'package:flutter_avaliacao/Pages/TodoList.dart';
import 'package:flutter_avaliacao/Pages/Moedas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List _pages; // Agora `_pages` é declarado como late

  @override
  void initState() {
    super.initState();

    _pages = [
      Inicio(),
      Clima(onLocationChanged: _updateLocation),
      Moedas(),
      TodoList(),
    ];
  }

  void _updateLocation(String newLocation) {
    setState(() {
      print('Nova Localização: $newLocation');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (_index) {
          setState(() {
            _currentIndex = _index;
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Clima",
            icon: Icon(Icons.cloud),
          ),
          BottomNavigationBarItem(
            label: "Moedas",
            icon: Icon(Icons.currency_bitcoin),
          ),
          BottomNavigationBarItem(
            label: "Tarefas",
            icon: Icon(Icons.subscriptions),
          ),
        ],
      ),
    );
  }
}