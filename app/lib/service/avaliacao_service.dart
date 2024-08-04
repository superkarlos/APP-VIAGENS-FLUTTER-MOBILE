import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:My_App/model/avaliacao.dart';

class AvaliacaoService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';

  List<Avaliacao> _avaliacoes = [];

  List<Avaliacao> get avaliacoes {
    fetchAvaliacoes();
    return [..._avaliacoes];
  }

  Future<void> addAvaliacao(Avaliacao avaliacao) async {
    try {
      fetchAvaliacoes();
      final int lastId = _avaliacoes.isNotEmpty ? _avaliacoes.last.id : 0;
      final newId = lastId + 1;

      final response = await http.post(
        Uri.parse('$baseUrl/avaliacoes.json'),
        body: jsonEncode({
          'id': newId,
          'usuario_nome': avaliacao.usuario_nome,
          'destino_id': avaliacao.destino_id,
          'avaliacao': avaliacao.avaliacao,
        }),
      );

      if (response.statusCode == 200) {
        _avaliacoes.add(Avaliacao(
          id: newId,
          usuario_nome: avaliacao.usuario_nome,
          destino_id: avaliacao.destino_id,
          avaliacao: avaliacao.avaliacao,
        ));
        notifyListeners();
      } else {
        print('Falha ao adicionar avaliação: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to add Avaliacao: $error');
      throw error;
    }
  }

  Future<void> updateAvaliacao(Avaliacao avaliacao) async {
    int index = _avaliacoes.indexWhere((p) => p.id == avaliacao.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$baseUrl/avaliacoes/${avaliacao.id}.json'),
        body: jsonEncode({
          'id': avaliacao.id,
          'usuario_nome': avaliacao.usuario_nome,
          'destino_id': avaliacao.destino_id,
          'avaliacao': avaliacao.avaliacao,
        }),
      );
      _avaliacoes[index] = avaliacao;
      notifyListeners();
    }
  }

  Future<void> removeAvaliacao(Avaliacao avaliacao) async {
    int index = _avaliacoes.indexWhere((p) => p.id == avaliacao.id);

    if (index >= 0) {
      await http.delete(Uri.parse('$baseUrl/avaliacoes/${avaliacao.id}.json'));
      _avaliacoes.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> fetchAvaliacoes() async {
    final url = Uri.parse('$baseUrl/avaliacoes.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody == null) {
          print('Nenhum dado encontrado no servidor');
          return;
        }

        final Map<String, dynamic> data = responseBody as Map<String, dynamic>;
        List<Avaliacao> loadedAvaliacoes = [];
        data.forEach((id, avaliacaoData) {
          if (avaliacaoData != null) {
            loadedAvaliacoes.add(Avaliacao.fromJson(avaliacaoData));
          }
        });

        _avaliacoes = loadedAvaliacoes;
        notifyListeners();
      } else {
        print('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar avaliações: $error');
      throw error;
    }
  }
}
