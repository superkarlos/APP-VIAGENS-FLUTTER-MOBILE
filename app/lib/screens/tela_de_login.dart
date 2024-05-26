
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:My_App/screens/tela_principal.dart';
import 'package:My_App/screens/tela_de_cadastro.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 120),
                const SizedBox(height: 48),
                _buildTextField(
                  controller: _usernameController,
                  labelText: 'Nome de Usuário',
                  icon: Icons.person,
                  isPassword: false,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Senha',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                _buildLoginButton(context),
                _buildSignUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  _togglePasswordVisibility();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _login(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(double.infinity, 50), // width and height
      ),
      child: const Text('Login'),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaCadastro()),
        );
      },
      child: const Text(
        'Cadastrar-se',
        style: TextStyle(color: Colors.deepPurple),
      ),
    );
  }

 Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final url =
          'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/users.json';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum dado encontrado no servidor')),
          );
          return;
        }

        final Map<String, dynamic>? data = json.decode(response.body);
        if (data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum dado encontrado no servidor')),
          );
          return;
        }

        bool userFound = false;
        bool passwordCorrect = false;
        int userId = 0;

        data.forEach((id, userData) {
          if (userData['usuario'] == username) {
            userFound = true;
            if (userData['senha'] == password) {
              passwordCorrect = true;
              userId = userData['id'];
            }
          }
        });

        if (userFound && passwordCorrect) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TelaPrincipal(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciais inválidas')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao conectar ao servidor')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $error')),
      );
    }
  }
}

/*
import 'dart:convert';
import 'package:My_App/screens/tela_principal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/screens/tela_de_cadastro.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 231, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/images/flutter.png"),
                ),
                const SizedBox(height: 70),
                TextField(
                  controller: _usernameController,
                  decoration:
                      const InputDecoration(labelText: 'Nome de Usuário'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility_off),
                      onPressed: () {
                        // Functionality to toggle password visibility can be added here if needed
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _login(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 199, 229, 253),
                        foregroundColor: Colors.purple,
                      ),
                      child: const Text('Login'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelaCadastro()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 199, 229, 253),
                        foregroundColor: Colors.purple,
                      ),
                      child: const Text('Cadastrar-se'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final url =
          'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/users.json';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum dado encontrado no servidor')),
          );
          return;
        }

        final Map<String, dynamic>? data = json.decode(response.body);
        if (data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum dado encontrado no servidor')),
          );
          return;
        }

        bool userFound = false;
        bool passwordCorrect = false;
        int userId = 0;

        data.forEach((id, userData) {
          if (userData['usuario'] == username) {
            userFound = true;
            if (userData['senha'] == password) {
              passwordCorrect = true;
              userId = userData['id'];
            }
          }
        });

        if (userFound && passwordCorrect) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TelaPrincipal(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciais inválidas')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao conectar ao servidor')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $error')),
      );
    }
  }
}
*/