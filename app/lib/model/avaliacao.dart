import 'package:flutter/material.dart';

class Avaliacao with ChangeNotifier {
  int id;
  int usuario_id;
  int destino_id;
  String avaliacao;
  String? foto_url;

  Avaliacao({
    required this.id,
    required this.usuario_id,
    required this.destino_id,
    required this.avaliacao,
    this.foto_url,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'] as int,
      usuario_id: json['usuario_id'] as int,
      destino_id: json['destino_id'] as int,
      avaliacao: json['avaliacao'] as String,
      foto_url: json['foto_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuario_id,
      'destino_id': destino_id,
      'avaliacao': avaliacao,
      'foto_url': foto_url,
    };
  }
}
