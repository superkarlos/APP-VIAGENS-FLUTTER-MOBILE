import 'package:flutter/material.dart';

class Avaliacao with ChangeNotifier {
  int id;
  int usuarioId;
  String usuario_nome;
  int destino_id;
  String avaliacao;
  List<String>? foto_urls;

  Avaliacao({
    required this.id,
    required this.usuarioId,
    required this.usuario_nome,
    required this.destino_id,
    required this.avaliacao,
    this.foto_urls,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'] ?? 0,
      usuarioId: json['usuarioId'] ?? 0,
      usuario_nome: json['usuario_nome'] ?? '',
      destino_id: json['destino_id'] ?? 0,
      avaliacao: json['avaliacao'] ?? '',
      foto_urls: (json['foto_urls'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'usuario_nome': usuario_nome,
      'destino_id': destino_id,
      'avaliacao': avaliacao,
      'foto_urls': foto_urls,
    };
  }
}
