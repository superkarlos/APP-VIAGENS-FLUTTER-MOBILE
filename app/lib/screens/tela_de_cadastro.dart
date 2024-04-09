import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:My_App/main.dart';
import 'package:My_App/model/Usuario.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Cadastro(),
      routes: {
        '/main.dart': (context) => const MeuApp()
      },
    );
  }
}

class Cadastro extends StatefulWidget {

  const Cadastro({super.key});


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
        title: const Text('Cadastrar usuário'),
        backgroundColor: Colors.blue,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/main.dart');
            },
            child: const Text(
              'Voltar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 213, 231, 245),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Digite seu nome: ',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Cor da borda quando em foco
                  ),
                  ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number, 
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: 'Digite sua idade: ',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: saldoController,
                keyboardType: TextInputType.number, 
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: 'Digite com quanto você deseja iniciar:',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nomeUsuarioController,
                decoration: const InputDecoration(
                  labelText: 'Escolha um nome de usuário:',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Escolha uma senha:',
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
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
              const SizedBox(height: 10),
              errorMessage != null 
              ? 
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              )
              :
              const SizedBox(),
        
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
                      const SnackBar(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
