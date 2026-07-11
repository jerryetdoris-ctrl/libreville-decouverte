import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/lieux_controller.dart';
import 'accueil_screen.dart';
import 'carte_screen.dart';
import 'favoris_screen.dart';
import 'profil_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indexActuel = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  final _ecrans = const [
    AccueilScreen(),
    CarteScreen(),
    FavorisScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Libreville Découverte')),
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(index: _indexActuel, children: _ecrans),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexActuel,
        onDestinationSelected: (index) {
          if (index == 0) {
            context.read<LieuxController>().reinitialiserFiltres();
          }
          setState(() => _indexActuel = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Carte'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoris'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}