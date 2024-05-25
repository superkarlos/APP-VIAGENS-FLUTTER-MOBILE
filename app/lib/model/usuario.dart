import 'package:flutter/cupertino.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/foto.dart';

class Usuario with ChangeNotifier {
  final int id;
  final String nome;
  final String usuario;
  final String senha;
  List<Destino> destinos;
  List<Foto> fotos;

  Usuario({
    required this.id,
    required this.nome,
    required this.usuario,
    required this.senha,
    required this.destinos,
    required this.fotos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
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
