import 'package:flutter/material.dart';
import 'package:ola_mundo/screens/TelaCadastro.dart';
import 'package:ola_mundo/screens/TelaLogin.dart';
import 'package:ola_mundo/screens/TelaPrincipal.dart';
import 'model/Destino.dart';
import 'model/Usuario.dart';
import 'telas/cadastrarDestino.dart';
import 'telas/showDestino.dart';
import 'telas/listarViagensReservadas.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _carregarUsuario(),
        builder: (context, AsyncSnapshot<Usuario?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            return TelaPrincipal(snapshot.data!);
          }
          return TelaLogin();
        },
      ),
      routes: {
        '/screens/TelaCadastro.dart': (context) => TelaCadastro()
      },
    );
  }

  Future<Usuario?> _carregarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nome = prefs.getString('nome');
    int? idade = prefs.getInt('idade');
    double? saldo = prefs.getDouble('saldo');
    String? nomeUsuario = prefs.getString('nomeUsuario');
    String? senha = prefs.getString('senha');

    if (nome != null &&
        idade != null &&
        saldo != null &&
        nomeUsuario != null &&
        senha != null) {
      return Usuario(
        nome: nome,
        idade: idade,
        saldo: saldo,
        nomeUsuario: nomeUsuario,
        senha: senha,
      );
    }
    return null;
  }
}