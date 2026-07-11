import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'controllers/lieux_controller.dart';
import 'controllers/favoris_controller.dart';
import 'controllers/navigation_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Désactive le cache local de Firestore : chaque lecture va toujours
  // chercher la version la plus fraîche sur le serveur, ce qui évite
  // qu'une donnée modifiée récemment reste bloquée sur une ancienne
  // version côté téléphone.
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);

  runApp(const LibrevilleDecouverteApp());
}

class LibrevilleDecouverteApp extends StatelessWidget {
  const LibrevilleDecouverteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => LieuxController()),
        ChangeNotifierProvider(create: (_) => FavorisController()),
        ChangeNotifierProvider(create: (_) => NavigationController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Libreville Découverte',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1F4B3F),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return StreamBuilder(
      stream: authController.etatConnexion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          // On initialise les favoris de CET utilisateur précis
          // dès qu'on sait qu'il est connecté, avant d'afficher l'accueil.
          context.read<FavorisController>().initialiser(snapshot.data!.uid);

          return const HomeShell();
        }
        return const LoginScreen();
      },
    );
  }
}