import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Usuario with ChangeNotifier {
  int id;
  String nome;
  int idade;
  double saldo;
  String nomeUsuario;
  String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.idade,
    required this.saldo,
    required this.nomeUsuario,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'saldo': saldo,
      'nomeUsuario': nomeUsuario,
      'senha': senha,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      idade: json['idade'],
      saldo: json['saldo'],
      nomeUsuario: json['nomeUsuario'],
      senha: json['senha'],
    );
  }
}
