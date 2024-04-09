import 'dart:convert';
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

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'idade': idade,
      'saldo': saldo,
      'nomeUsuario': nomeUsuario,
      'senha': senha,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'],
      idade: json['idade'],
      saldo: json['saldo'],
      nomeUsuario: json['nomeUsuario'],
      senha: json['senha'],
    );
  }

  Future<void> salvarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? usuariosJson = prefs.getStringList('usuarios');
    List<Usuario> usuarios = [];

    // Verificar se já existem usuários salvos
    if (usuariosJson != null) {
      usuarios = usuariosJson.map((usuarioJson) => Usuario.fromJson(json.decode(usuarioJson))).toList();
    }

    // Verificar se o nome de usuário já existe
    bool nomeDeUsuarioExiste = usuarios.any((usuario) => usuario.nomeUsuario == nomeUsuario);
    if (nomeDeUsuarioExiste) {
      throw Exception('Nome de usuário já existe. Por favor, escolha outro nome.');
    }

    // Salvar o novo usuário
    usuarios.add(this);
    List<String> usuariosAtualizados = usuarios.map((usuario) => json.encode(usuario.toJson())).toList();
    await prefs.setStringList('usuarios', usuariosAtualizados);
  }

  static Future<List<Usuario>> carregarUsuarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? usuariosJson = prefs.getStringList('usuarios');

    if (usuariosJson != null) {
      List<Usuario> usuarios = usuariosJson.map((usuarioJson) => Usuario.fromJson(json.decode(usuarioJson))).toList();
      return usuarios;
    }
    return [];
  }

}
