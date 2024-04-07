import 'package:flutter/material.dart';
import 'package:ola_mundo/main.dart';
import 'package:ola_mundo/model/Usuario.dart';
import 'package:flutter/services.dart';

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
  
  String? errorMessage;

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
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Digite seu nome: '),
              ),
              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number, 
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(labelText: 'Digite sua idade: '),
              ),
              TextField(
                controller: saldoController,
                keyboardType: TextInputType.number, 
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
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
              errorMessage != null 
              ? 
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  errorMessage!,
                  style: TextStyle(
                    color: Colors.red, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              )
              : 
              SizedBox(),
        
              ElevatedButton(
                onPressed: () async {
                  Usuario novoUsuario = Usuario(
                    nome: nomeController.text,
                    idade: int.tryParse(idadeController.text) ?? 0,
                    saldo: double.tryParse(saldoController.text) ?? 0,
                    nomeUsuario: nomeUsuarioController.text,
                    senha: senhaController.text,
                  );
                  try {
                    await novoUsuario.salvarUsuario();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cadastro realizado com sucesso!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pushNamed('/main.dart');
                  } catch (e) {
                    setState(() {
                      errorMessage = 'Esse nome de usuário já existe. Por favor, escolha outro.';
                    });
                  }
                },
                child: Text("Cadastrar")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
