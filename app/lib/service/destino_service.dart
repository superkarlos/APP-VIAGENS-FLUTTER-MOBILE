import 'dart:convert';

import 'package:My_App/model/avaliacao.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DestinoService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';

  List<Destino> destinos = [];
  ValueNotifier<int> updateNotifier = ValueNotifier(0);

  List<Destino> get items {
    fetchDestinos();
    return [...destinos];
  }

  void updateFavorites() {
    updateNotifier.value++;
    notifyListeners();
  }

  Future<void> addDestino(Destino destino) async {
    try {
      await fetchDestinos();
      final int lastId = destinos.isNotEmpty ? destinos.last.id ?? 0 : 0;
      final newId = (lastId + 1);

      final response = await http.post(
        Uri.parse('$baseUrl/destinos.json'),
        body: jsonEncode({
          "id": newId,
          "nome": destino.nome,
          "descricao": destino.descricao,
          "preco": destino.preco,
          "imagemUrl": destino.imagemUrl,
        }),
      );

      if (response.statusCode == 200) {
        //final id = jsonDecode(response.body)['name'];
        destinos.add(Destino(
          id: newId,
          descricao: destino.descricao,
          nome: destino.nome,
          preco: destino.preco,
          imagemUrl: destino.imagemUrl,
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

  Future<MapEntry<String, dynamic>?> _getFirebaseDestinyId(
      int destinyId) async {
    final url = Uri.parse('$baseUrl/destinos.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final userEntry = responseBody.entries.firstWhere(
        (entry) => entry.value['id'] == destinyId,
        orElse: () => MapEntry<String, dynamic>('not_found', null),
      );

      if (userEntry.key != 'not_found') {
        return userEntry;
      }
    } else {
      throw Exception(
          'Falha ao carregar destinos do Firebase: ${response.statusCode}');
    }

    return null;
  }

  Future<void> updateDestiny(Destino destino) async {
    try {
      // Find the Firebase ID
      final userEntry = await _getFirebaseDestinyId(destino.id);
      if (userEntry != null) {
        final firebaseId = userEntry.key;

        // Update the user in Firebase
        final response = await http.patch(
          Uri.parse('$baseUrl/destinos/$firebaseId.json'),
          body: jsonEncode({
            "id": destino.id,
            "nome": destino.nome,
            "descricao": destino.descricao,
            "preco": destino.preco,
            "imagemUrl": destino.imagemUrl,
          }),
        );

        if (response.statusCode == 200) {
          // Update the user in the local list
          final index = destinos.indexWhere((p) => p.id == destino.id);
          if (index >= 0) {
            destinos[index] = destino;
            notifyListeners();
          }
        } else {
          print('Falha ao atualizar destino: ${response.statusCode}');
        }
      } else {
        print('Destino não encontrado no Firebase.');
      }
    } catch (error) {
      print('Erro ao atualizar destino: $error');
      throw error;
    }
  }

  Future<void> removeDestiny(Destino destino) async {
    final userEntry = await _getFirebaseDestinyId(destino.id);
    if (userEntry != null) {
      final firebaseId = userEntry.key;
      int index = destinos.indexWhere((p) => p.id == destino.id);

      if (index >= 0) {
        await http.delete(Uri.parse('$baseUrl/destinos/$firebaseId.json'));
        destinos.removeAt(index);
        notifyListeners();
      }
    } else {
      print('Destino não encontrado no Firebase.');
    }
  }

  Future<void> fetchDestinos() async {
    final url = Uri.parse('$baseUrl/destinos.json');

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
      print('Erro ao carregar destinos: $error');
      throw error;
    }
  }

  Future<void> addAvaliacaoAoDestino(int destinoId, Avaliacao avaliacao) async {
    try {
      final userEntry = await _getFirebaseDestinyId(destinoId);
      if (userEntry != null) {
        final firebaseId = userEntry.key;

        final destino = Destino.fromJson(userEntry.value);
        destino.avaliacoes.add(avaliacao);

        final response = await http.patch(
          Uri.parse('$baseUrl/destinos/$firebaseId.json'),
          body: jsonEncode(destino.toJson()),
        );

        if (response.statusCode == 200) {
          final index = destinos.indexWhere((d) => d.id == destinoId);
          if (index >= 0) {
            destinos[index] = destino;
            notifyListeners();
          }
        } else {
          print('Falha ao atualizar destino: ${response.statusCode}');
        }
      } else {
        print('Destino não encontrado no Firebase.');
      }
    } catch (error) {
      print('Erro ao adicionar avaliação ao destino: $error');
      throw error;
    }
  }
}
