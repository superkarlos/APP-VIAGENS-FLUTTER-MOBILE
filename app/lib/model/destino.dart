import 'package:flutter/material.dart';

class Destino with ChangeNotifier {
  int id;
  String nome;
  String url_foto;

  Destino({
    required this.id,
    required this.nome,
    required this.url_foto,
  });

  factory Destino.fromJson(Map<String, dynamic> json) {
    return Destino(
      id: json['id'] as int,
      nome: json['nome'] as String,
      url_foto: json['url_foto'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'url_foto': url_foto,
    };
  }
}
