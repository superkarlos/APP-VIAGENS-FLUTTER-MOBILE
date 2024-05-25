import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  final int id;
  final String nome;
  final String usuario;
  final String senha;
  List<Destino> destinos;
  List<Fotos> fotos;

  User({
    required this.id,
    required this.nome,
    required this.usuario,
    required this.senha,
    required this.destinos,
    required this.fotos,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nome: json['nome'] as String,
      usuario: json['usuario'] as String,
      senha: json['senha'] as String,
      destinos: (json['destinos'] as List<dynamic>)
          .map((item) => Destino.fromJson(item as Map<String, dynamic>))
          .toList(),
      fotos: (json['fotos'] as List<dynamic>)
          .map((item) => Foto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'usuario': usuario,
      'senha': senha,
      'destinos': destinos.map((destino) => destino.toJson()).toList(),
    };
  }
}
