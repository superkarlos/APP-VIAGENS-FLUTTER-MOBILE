import 'dart:convert';

import 'package:My_App/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuarioService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';

  List<Usuario> _usuarios = [];

  Future<List<Usuario>> get items async {
    await fetchUsers();
    return [..._usuarios];
  }

  Future<void> addUser(Usuario usuario) async {
    try {
      await fetchUsers();
      final int lastId = _usuarios.isNotEmpty ? _usuarios.last.id ?? 0 : 0;
      final newId = (lastId + 1);

      final response = await http.post(
        Uri.parse('$baseUrl/users.json'),
        body: jsonEncode({
          "id": newId,
          "nome": usuario.nome,
          "usuario": usuario.usuario,
          "senha": usuario.senha,
          "saldo": usuario.saldo,
          "destinos": usuario.destinos,
          "fotos": usuario.fotos,
        }),
      );

      if (response.statusCode == 200) {
        usuario.id = newId;
        _usuarios.add(usuario);
        notifyListeners();
      } else {
        print('Falha ao adicionar usuário: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to add User: $error');
      throw error;
    }
  }

  Future<void> updateUser(Usuario usuario) async {
    int index = _usuarios.indexWhere((p) => p.id == usuario.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$baseUrl/users/${usuario.id}.json'),
        body: jsonEncode({
          "id": usuario.id,
          "nome": usuario.nome,
          "usuario": usuario.usuario,
          "senha": usuario.senha,
          "saldo": usuario.saldo,
          "destinos": usuario.destinos,
          "fotos": usuario.fotos,
        }),
      );
      _usuarios[index] = usuario;
      notifyListeners();
    }
  }

  Future<void> removeUser(Usuario usuario) async {
    int index = _usuarios.indexWhere((p) => p.id == usuario.id);

    if (index >= 0) {
      await http.delete(Uri.parse('$baseUrl/users/${usuario.id}.json'));
      _usuarios.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody == null) {
          print('Nenhum dado encontrado no servidor');
          return;
        }

        if (responseBody is Map<String, dynamic>) {
          List<Usuario> loadedUsers = [];
          responseBody.forEach((id, userData) {
            if (userData != null) {
              loadedUsers.add(Usuario.fromJson(userData));
            }
          });
          _usuarios = loadedUsers;
          notifyListeners();
        } else {
          print('Resposta do servidor não é um Map<String, dynamic>');
        }
      } else {
        print('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar usuários: $error');
      throw error;
    }
  }

  Future<bool> isUserExists(String usuarioNome) async {
    await fetchUsers();
    return _usuarios.any((usuario) => usuario.usuario == usuarioNome);
  }
}
