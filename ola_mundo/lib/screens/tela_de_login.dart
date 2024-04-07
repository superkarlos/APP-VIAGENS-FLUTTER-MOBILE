import 'package:flutter/material.dart';
import 'package:ola_mundo/model/Usuario.dart';
import 'package:ola_mundo/screens/tela_principal.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

   bool _obscureText = true;

void _entrar() async {
  if (_loginController.text.isEmpty || _senhaController.text.isEmpty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Campos vazios'),
          content: Text('Por favor, preencha todos os campos.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return;
  }

  List<Usuario> usuarios = await Usuario.carregarUsuarios();

  if (usuarios.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login ou senha incorretos. Por favor, tente novamente.'),
        duration: Duration(seconds: 2), // Duração do SnackBar
      ),
    );
    return;
  }

  Usuario? usuarioEncontrado;

  for (var usuario in usuarios) {
    if (usuario.nomeUsuario == _loginController.text && usuario.senha == _senhaController.text) {
      usuarioEncontrado = usuario;
      break;
    }
  }

  if (usuarioEncontrado != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TelaPrincipal(usuarioEncontrado!),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login ou senha incorretos. Por favor, tente novamente.'),
        duration: Duration(seconds: 2), // Duração do SnackBar
      ),
    );
    return;
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
              decoration: InputDecoration(labelText: 'Nome de usário'),
            ),
            TextField(
              controller: _senhaController,
               obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Senha',
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