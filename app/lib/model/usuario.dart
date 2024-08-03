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
      nome: json['nome'] != null ? json['nome'] as String : '',
      usuario: json['usuario'] != null ? json['usuario'] as String : '',
      senha: json['senha'] != null ? json['senha'] as String : '',
      saldo: (json['saldo'] as num?)?.toDouble() ?? 0.0,
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
      'nome': nome ?? '', // Trata o valor nulo como uma string vazia
      'usuario': usuario ?? '', // Trata o valor nulo como uma string vazia
      'senha': senha ?? '', // Trata o valor nulo como uma string vazia
      'saldo': saldo ?? 0.0, // Trata o valor nulo como 0.0
      'destinos': destinos?.map((destino) => destino.toJson()).toList() ?? [],
      'fotos': fotos?.map((foto) => foto.toJson()).toList() ?? [],
    };
  }

  void depositar(double valor){
    saldo += valor;
    notifyListeners();
  }
}
