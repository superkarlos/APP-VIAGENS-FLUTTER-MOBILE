import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:My_App/model/usuario.dart';

class UsuarioService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Usuario> _usuarios = [];
  bool uploading = false;
  bool loadingImage = false;
  double total = 0;
  Reference? lastUploadedRef;
  String? lastUploadedImageUrl;

  Future<List<Usuario>> get items async {
    await fetchUsers();
    return [..._usuarios];
  }

  Future<void> addUser(Usuario usuario) async {
    try {
      await fetchUsers();
      final int lastId = _usuarios.isNotEmpty ? _usuarios.last.id : 0;
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
          "imagemPerfil": usuario.imagemPerfil,
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

  Future<MapEntry<String, dynamic>?> _getFirebaseUserId(int userId) async {
    final url = Uri.parse('$baseUrl/users.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final userEntry = responseBody.entries.firstWhere(
        (entry) => entry.value['id'] == userId,
        orElse: () => MapEntry<String, dynamic>('not_found', null),
      );

      if (userEntry.key != 'not_found') {
        return userEntry;
      }
    } else {
      throw Exception('Falha ao carregar usuários do Firebase: ${response.statusCode}');
    }

    return null;
  }

  Future<void> updateUser(Usuario usuario) async {
    try {
      final userEntry = await _getFirebaseUserId(usuario.id);
      if (userEntry != null) {
        final firebaseId = userEntry.key;

        final response = await http.patch(
          Uri.parse('$baseUrl/users/$firebaseId.json'),
          body: jsonEncode({
            "id": usuario.id,
            "nome": usuario.nome,
            "usuario": usuario.usuario,
            "senha": usuario.senha,
            "saldo": usuario.saldo,
            "destinos": usuario.destinos,
            "imagemPerfil": usuario.imagemPerfil,
          }),
        );

        if (response.statusCode == 200) {
          final index = _usuarios.indexWhere((p) => p.id == usuario.id);
          if (index >= 0) {
            _usuarios[index] = usuario;
            notifyListeners();
          }
        } else {
          print('Falha ao atualizar usuário: ${response.statusCode}');
        }
      } else {
        print('Usuário não encontrado no Firebase.');
      }
    } catch (error) {
      print('Erro ao atualizar usuário: $error');
      throw error;
    }
  }

  Future<void> removeUser(Usuario usuario) async {
    final userEntry = await _getFirebaseUserId(usuario.id);
    if (userEntry != null) {
      final firebaseId = userEntry.key;
      int index = _usuarios.indexWhere((p) => p.id == usuario.id);

      if (index >= 0) {
        await http.delete(Uri.parse('$baseUrl/users/$firebaseId.json'));
        _usuarios.removeAt(index);
        notifyListeners();
      }
    } else {
      print('Usuário não encontrado no Firebase.');
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

  Usuario findUserById(int id) {
    final user = _usuarios.firstWhere((user) => user.id == id,
        orElse: () => Usuario(
            id: 0,
            nome: '',
            usuario: '',
            senha: '',
            saldo: 0.0,
            destinos: [],
            fotos: [])); // Adicionei um usuário dummy com id 0
    return user.id != 0
        ? user
        : Usuario(
            id: 0,
            nome: '',
            usuario: '',
            senha: '',
            saldo: 0.0,
            destinos: [],
            fotos: []); // Retornando usuário vazio com id 0
  }

  Future<void> loadLastImage(int userId) async {
    loadingImage = true;
    notifyListeners();
    try {
      var refs = (await _storage.ref('profile-images/$userId').listAll()).items;
      if (refs.isNotEmpty) {
        lastUploadedRef = refs.last;
        lastUploadedImageUrl = await lastUploadedRef!.getDownloadURL();
      } else {
        lastUploadedImageUrl = null;
      }
    } finally {
      loadingImage = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadImage(ImageSource source, int userId) async {
    final ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      File imageFile = File(file.path);
      String ref = 'profile-images/$userId/img-${DateTime.now().toString()}.jpg';
      UploadTask task = _storage.ref(ref).putFile(imageFile);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          uploading = true;
          total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          notifyListeners();
        } else if (snapshot.state == TaskState.success) {
          lastUploadedRef = snapshot.ref;
          lastUploadedImageUrl = await lastUploadedRef!.getDownloadURL();
          uploading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> deleteImage() async {
    if (lastUploadedRef != null) {
      await _storage.ref(lastUploadedRef!.fullPath).delete();
      lastUploadedRef = null;
      lastUploadedImageUrl = null;
      notifyListeners();
    }
  }
}
