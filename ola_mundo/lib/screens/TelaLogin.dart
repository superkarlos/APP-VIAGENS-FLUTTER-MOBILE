import 'package:flutter/material.dart';
import 'package:ola_mundo/model/Usuario.dart';
import 'package:ola_mundo/screens/TelaPrincipal.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _entrar() {
    if (_loginController.text == 'adm' && _senhaController.text == '1234') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              TelaPrincipal(Usuario(nome: "Administrador", idade: 30, saldo: 3000.0, nomeUsuario: "Administrador", senha: "123456"))));
    } else {
      // Mostrar mensagem de erro de login
      // aqui voces colocam para mostrar msg de erro
    }
  } 

  void _cadastrarUsuario(){
      Navigator.of(context).pushNamed('/screens/TelaCadastro.dart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _entrar,
                  child: Text('Entrar'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _cadastrarUsuario,
                  child: Text('Cadastrar-se')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}