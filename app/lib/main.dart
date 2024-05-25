import 'package:My_App/screens/tela_de_cadastro.dart';
import 'package:My_App/screens/tela_de_login.dart';
import 'package:flutter/material.dart';
import 'package:My_App/utils/routes.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        AppRoutes.MAINPAGE: (context) => const MeuApp(),
        AppRoutes.CADASTRO: (context) => const TelaCadastro(),
      },
    );
  }
}
