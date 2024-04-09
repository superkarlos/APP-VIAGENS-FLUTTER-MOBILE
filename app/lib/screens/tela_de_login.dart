import 'package:flutter/material.dart';
import 'package:My_App/model/Usuario.dart';
import 'package:My_App/screens/tela_principal.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _obscureText = true;

  void _entrar() async {
    if (_loginController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    List<Usuario> usuarios = await Usuario.carregarUsuarios();

    if (usuarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Login ou senha incorretos. Por favor, tente novamente.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Usuario? usuarioEncontrado;

    for (var usuario in usuarios) {
      if (usuario.nomeUsuario == _loginController.text &&
          usuario.senha == _senhaController.text) {
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
          content:
              Text('Login ou senha incorretos. Por favor, tente novamente.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
  }

  void _cadastrarUsuario() {
    Navigator.of(context).pushNamed('/screens/TelaCadastro.dart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 231, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/images/flutter.png"),
                ),
                const SizedBox(
                  height: 70,
                ),
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(labelText: 'Nome de usuário'),
                ),
                TextField(
                  controller: _senhaController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
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
                SizedBox(height: 15),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _entrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 199, 229, 253),
                        foregroundColor: Colors.purple,
                      ),
                      child: Text('Entrar'),
                    ),
                    Spacer(),
                    ElevatedButton(
                        onPressed: _cadastrarUsuario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 199, 229, 253),
                          foregroundColor: Colors.purple,
                        ),
                        child: Text('Cadastrar-se')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
