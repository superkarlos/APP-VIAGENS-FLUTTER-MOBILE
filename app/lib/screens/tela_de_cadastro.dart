import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:provider/provider.dart';
import 'package:My_App/utils/routes.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  bool _obscureText = true;
  final nomeController = TextEditingController();
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
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (errorMessage != null)
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
                ),
              ElevatedButton(
                onPressed: () async {
                  Usuario novoUsuario = Usuario(
                    id: 0,
                    nome: nomeController.text,
                    usuario: nomeUsuarioController.text,
                    senha: senhaController.text,
                    saldo: double.tryParse(saldoController.text) ?? 0,
                    destinos: [],
                    fotos: [],
                  );

                  final userList =
                      Provider.of<UsuarioService>(context, listen: false);
                  final userNameExists =
                      await userList.isUserExists(novoUsuario.usuario);
                  if (userNameExists) {
                    setState(() {
                      errorMessage =
                          'Já existe um usuário com esse nome do usuário. Por favor, escolha outro.';
                    });
                  } else {
                    try {
                      await userList.addUser(novoUsuario);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cadastro realizado com sucesso!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pushNamed(AppRoutes.MAIN_PAGE);
                    } catch (e) {
                      setState(() {
                        errorMessage =
                            'Erro ao cadastrar usuário: ${e.toString()}';
                      });
                    }
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
