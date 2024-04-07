import 'package:shared_preferences/shared_preferences.dart';

class Usuario {
  String nome;
  int idade;
  double saldo;
  String nomeUsuario;
  String senha;

  Usuario({
    required this.nome,
    required this.idade,
    required this.saldo,
    required this.nomeUsuario,
    required this.senha,
  });

  Future<void> cadastrarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', nome);
    await prefs.setInt('idade', idade);
    await prefs.setDouble('saldo', saldo);
    await prefs.setString('nomeUsuario', nomeUsuario);
    await prefs.setString('senha', senha);
  }
}
