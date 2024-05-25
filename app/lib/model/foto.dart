import 'package:flutter/material.dart';

class Foto with ChangeNotifier {
  int id;
  int usuario_id;
  String url;

  Foto({
    required this.id,
    required this.usuario_id,
    required this.url,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['id'] as int,
      usuario_id: json['usuario_id'] as int,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuario_id,
      'url': url,
    };
  }
}
