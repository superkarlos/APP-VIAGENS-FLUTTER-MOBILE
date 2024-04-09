import 'package:My_App/screens/tela_de_cadastro.dart';
import 'package:My_App/screens/tela_de_login.dart';
import 'package:flutter/material.dart';

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
      home: const TelaLogin(),
      routes: {
        '/screens/TelaCadastro.dart': (context) => const TelaCadastro()
      },
    );
  }
}