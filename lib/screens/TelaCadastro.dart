import 'package:flutter/material.dart';
import 'package:main/main.dart';


class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Cadastro(),
      routes: {
        '/main.dart': (context) => MeuApp()
      },
    );
  }
}

class Cadastro extends StatelessWidget {
  const Cadastro({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar usuário'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/main.dart');
            },
            child: Text(
              'Voltar',
              style: TextStyle(color: Colors.black), // Alterado para cor preta
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Digite seu nome: '),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Digite sua idade: '),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Digite com quanto você deseja iniciar: '),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Escolha um nome de usuário: '),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Escolha uma senha: '),
            ),
          ],
        ),
      ),
    );
  }
}
