import 'dart:convert';

import 'package:My_App/model/Destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DestinoService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';

  List<Destino> destinos = [];

  List<Destino> get items {
    fetchDestinos();
    return [...destinos];
  }

  Future<void> addDestino(Destino destino) async {
    try {
      fetchDestinos();
      final int lastId = destinos.isNotEmpty ? destinos.last.id ?? 0 : 0;
      final newId = (lastId + 1);

      final response = await http.post(
        Uri.parse('$baseUrl/destinos.json'),
        body: jsonEncode({
          "id": newId,
          "nome": destino.nome,
          "url_foto": destino.url_foto,
        }),
      );

      if (response.statusCode == 200) {
        //final id = jsonDecode(response.body)['name'];
        destinos.add(Destino(
          id: newId,
          nome: destino.nome,
          url_foto: destino.url_foto,
        ));
        notifyListeners();
      } else {
        print('Falha ao adicionar destino: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to add User: $error');
      throw error;
    }
  }

  Future<void> updateUser(Destino destino) async {
    int index = destinos.indexWhere((p) => p.id == destino.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$baseUrl/destinos/${destino.id}.json'),
        body: jsonEncode({
          "id": destino.id,
          "nome": destino.nome,
          "url_foto": destino.url_foto,
        }),
      );
      destinos[index] = destino;
      notifyListeners();
    }
  }

  Future<void> removeUser(Destino destino) async {
    int index = destinos.indexWhere((p) => p.id == destino.id);

    if (index >= 0) {
      await http.delete(Uri.parse('$baseUrl/users/${destino.id}.json'));
      destinos.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> fetchDestinos() async {
    final url = Uri.parse('$baseUrl/users.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody == null) {
          print('Nenhum dado encontrado no servidor');
          return;
        }

        final Map<String, dynamic> data = responseBody as Map<String, dynamic>;
        List<Destino> loadedusers = [];
        data.forEach((id, userData) {
          if (userData != null) {
            loadedusers.add(Destino.fromJson(userData));
          }
        });

        destinos = loadedusers;
        notifyListeners();
      } else {
        print('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar usuários: $error');
      throw error;
    }
  }
}
