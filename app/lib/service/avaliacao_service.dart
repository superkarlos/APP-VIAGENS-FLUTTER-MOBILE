import 'dart:convert';
import 'dart:io';
import 'package:My_App/service/destino_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:My_App/model/avaliacao.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AvaliacaoService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Avaliacao> _avaliacoes = [];

  bool uploading = false;
  bool loadingImage = false;
  double total = 0;
  List<Reference> refs = [];
  List<String> arquivos = [];

  List<Avaliacao> get avaliacoes {
    fetchAvaliacoes();
    return [..._avaliacoes];
  }

  Future<void> addAvaliacao(BuildContext context, Avaliacao avaliacao) async {
    try {
      fetchAvaliacoes();
      final int lastId = _avaliacoes.isNotEmpty ? _avaliacoes.last.id : 0;
      final newId = lastId + 1;

      final response = await http.post(
        Uri.parse('$baseUrl/avaliacoes.json'),
        body: jsonEncode({
          'id': newId,
          'usuarioId': avaliacao.usuarioId,
          'usuario_nome': avaliacao.usuario_nome,
          'destino_id': avaliacao.destino_id,
          'avaliacao': avaliacao.avaliacao,
          'foto_urls': avaliacao.foto_urls,
        }),
      );

      if (response.statusCode == 200) {
        _avaliacoes.add(Avaliacao(
          id: newId,
          usuarioId: avaliacao.usuarioId,
          usuario_nome: avaliacao.usuario_nome,
          destino_id: avaliacao.destino_id,
          avaliacao: avaliacao.avaliacao,
          foto_urls: avaliacao.foto_urls,
        ));
        notifyListeners();

        await Provider.of<DestinoService>(context, listen: false).addAvaliacaoAoDestino(
          avaliacao.destino_id,
          Avaliacao(
            id: newId,
            usuarioId: avaliacao.usuarioId,
            usuario_nome: avaliacao.usuario_nome,
            destino_id: avaliacao.destino_id,
            avaliacao: avaliacao.avaliacao,
            foto_urls: avaliacao.foto_urls,
          )
        );
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
          'usuarioId': avaliacao.usuarioId,
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

  Future<void> loadImages() async {
    loadingImage = true;
    notifyListeners();
    try {
      fetchAvaliacoes();
      final int lastId = _avaliacoes.isNotEmpty ? _avaliacoes.last.id : 0;
      final newId = lastId + 1;
      refs = (await _storage.ref('rating-images/$newId').listAll()).items;
      for(var ref in refs) {
        arquivos.add(await ref.getDownloadURL());
      }
    } finally {
      loadingImage = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      File imageFile = File(file.path);
      fetchAvaliacoes();
      final int lastId = _avaliacoes.isNotEmpty ? _avaliacoes.last.id : 0;
      final newId = lastId + 1;
      String ref = 'rating-images/$newId/img-${DateTime.now().toString()}.jpg';
      UploadTask task = _storage.ref(ref).putFile(imageFile);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          uploading = true;
          total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          notifyListeners();
        } else if (snapshot.state == TaskState.success) {
          arquivos.add(await snapshot.ref.getDownloadURL());
          refs.add(snapshot.ref);
          uploading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> deleteImage(int index) async {
    await _storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
    notifyListeners();
  }

}
