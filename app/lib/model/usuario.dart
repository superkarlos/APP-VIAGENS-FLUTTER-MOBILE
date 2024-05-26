import 'package:flutter/cupertino.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/foto.dart';

class Usuario with ChangeNotifier {
  int id;
  String nome;
  String usuario;
  String senha;
  double saldo;
  List<Destino> destinos;
  List<Foto> fotos;

  Usuario({
    required this.id,
    required this.nome,
    required this.usuario,
    required this.senha,
    required this.saldo,
    required this.destinos,
    required this.fotos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nome: json['nome'] as String,
      usuario: json['usuario'] as String,
      senha: json['senha'] as String,
      saldo: json['saldo'] as double,
      destinos: (json['destinos'] as List<dynamic>?)
              ?.map((item) => Destino.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      fotos: (json['fotos'] as List<dynamic>?)
              ?.map((item) => Foto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'usuario': usuario,
      'senha': senha,
      'destinos': destinos.map((destino) => destino.toJson()).toList(),
      'fotos': fotos.map((foto) => foto.toJson()).toList(),
    };
  }
}
