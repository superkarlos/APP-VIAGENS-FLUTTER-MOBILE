import 'package:flutter/material.dart';

class Destino with ChangeNotifier {
  int id;
  String nome;
  double preco;
  String url_foto;

  Destino({
    required this.id,
    required this.nome,
    required this.preco,
    required this.url_foto,
  });

  factory Destino.fromJson(Map<String, dynamic> json) {
    return Destino(
      id: json['id'] as int,
      nome: json['nome'] as String,
      preco: json['preco'] as double,
      url_foto: json['url_foto'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'url_foto': url_foto,
    };
  }
}
