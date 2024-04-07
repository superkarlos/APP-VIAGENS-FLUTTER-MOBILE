import 'package:flutter/material.dart';
import 'package:ola_mundo/screens/tela_de_cadastro.dart';
import 'package:ola_mundo/screens/tela_de_login.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaLogin(),
      routes: {
        '/screens/TelaCadastro.dart': (context) => TelaCadastro()
      },
    );
  }

}