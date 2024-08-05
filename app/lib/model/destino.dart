import 'package:My_App/model/avaliacao.dart';
import 'package:flutter/material.dart';

class Destino with ChangeNotifier {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;
  final List<Avaliacao> avaliacoes;

  Destino({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
    this.avaliacoes = const [],
  });

  factory Destino.fromJson(Map<String, dynamic> json) {
    return Destino(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] ?? 0.0).toDouble(),
      imagemUrl: json['imagemUrl'] ?? '',
      avaliacoes: (json['avaliacoes'] as List<dynamic>?)?.map((avaliacaoJson) => Avaliacao.fromJson(avaliacaoJson)).toList() ??[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "descricao": descricao,
      "preco": preco,
      "imagemUrl": imagemUrl,
      "avaliacoes": avaliacoes.map((avaliacao) => avaliacao.toJson()).toList(),
    };
  }
}
