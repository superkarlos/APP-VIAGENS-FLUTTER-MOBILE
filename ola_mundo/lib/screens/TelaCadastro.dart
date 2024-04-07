import 'package:flutter/material.dart';
import 'package:ola_mundo/main.dart';
import 'package:ola_mundo/model/Usuario.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({Key? key});

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

class Cadastro extends StatefulWidget {

  Cadastro({Key? key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  bool _obscureText = true;

  final nomeController = TextEditingController();

  final idadeController = TextEditingController();

  final saldoController = TextEditingController();

  final nomeUsuarioController = TextEditingController();

  final senhaController = TextEditingController();

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
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Digite seu nome: '),
            ),
            TextField(
              controller: idadeController,
              decoration: InputDecoration(labelText: 'Digite sua idade: '),
            ),
            TextField(
              controller: saldoController,
              decoration: InputDecoration(
                  labelText: 'Digite com quanto você deseja iniciar: '),
            ),
            TextField(
              controller: nomeUsuarioController,
              decoration: InputDecoration(
                  labelText: 'Escolha um nome de usuário: '),
            ),
            TextField(
              controller: senhaController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Escolha uma senha: ',
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Usuario usuario = Usuario(
                  nome: nomeController.text,
                  idade: int.tryParse(idadeController.text) ?? 0,
                  saldo: double.tryParse(saldoController.text) ?? 0,
                  nomeUsuario: nomeUsuarioController.text,
                  senha: senhaController.text,
                );
                usuario.cadastrarUsuario();
              }, 
              child: Text("Cadastrar")
            )
          ],
        ),
      ),
    );
  }
}