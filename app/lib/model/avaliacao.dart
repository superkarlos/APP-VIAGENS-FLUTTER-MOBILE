import 'package:flutter/material.dart';

class Avaliacao with ChangeNotifier {
  int id;
  String usuario_nome;
  int destino_id;
  String avaliacao;
  List<String>? foto_urls;

  Avaliacao({
    required this.id,
    required this.usuario_nome,
    required this.destino_id,
    required this.avaliacao,
    this.foto_urls,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'] as int,
      usuario_nome: json['usuario_id'] as String,
      destino_id: json['destino_id'] as int,
      avaliacao: json['avaliacao'] as String,
      foto_urls: (json['foto_urls'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuario_nome,
      'destino_id': destino_id,
      'avaliacao': avaliacao,
      'foto_urls': foto_urls,
    };
  }
}
