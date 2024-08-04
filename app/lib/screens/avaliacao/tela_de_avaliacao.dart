import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/model/avaliacao.dart';
import '../../service/avaliacao_service.dart';
import '../../service/destino_service.dart';
import '../../service/usuario_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AvaliacaoPage extends StatefulWidget {
  final Usuario usuario;

  AvaliacaoPage({required this.usuario});

  @override
  _AvaliacaoPageState createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  final TextEditingController _comentarioController = TextEditingController();
  Destino? _destinoSelecionado;
  List<File> _imagens = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Provider.of<UsuarioService>(context, listen: false).fetchUsers();
    Provider.of<DestinoService>(context, listen: false).fetchDestinos();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imagens.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avaliacoes = Provider.of<AvaliacaoService>(context).avaliacoes;
    final destinosDisponiveis = Provider.of<DestinoService>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
      body: ListView.builder(
        itemCount: avaliacoes.length,
        itemBuilder: (context, index) {
          final avaliacao = avaliacoes[index];
          final destino = destinosDisponiveis.firstWhere((destino) => destino.id == avaliacao.destino_id);
          return ListTile(
            title: Text('Local: ${destino.nome}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuário: ${avaliacao.usuario_nome}'),
                Text('Comentário: ${avaliacao.avaliacao}'),
                if (avaliacao.foto_urls != null)
                  ...avaliacao.foto_urls!.map((url) => Image.network(url)).toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormularioAvaliacao(context, destinosDisponiveis);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormularioAvaliacao(BuildContext context, List<Destino> destinosDisponiveis) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deixe sua avaliação'),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<Destino>(
                  hint: Text('Selecione o destino'),
                  value: _destinoSelecionado,
                  onChanged: (Destino? novoDestino) {
                    setState(() {
                      _destinoSelecionado = novoDestino;
                    });
                  },
                  items: destinosDisponiveis.map((destino) {
                    return DropdownMenuItem<Destino>(
                      value: destino,
                      child: Text(destino.nome),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _comentarioController,
                  decoration: InputDecoration(labelText: 'Seu comentário'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                if (_imagens.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _imagens.map((imagem) {
                      return Stack(
                        children: [
                          Image.file(
                            imagem,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imagens.remove(imagem);
                                });
                              },
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_destinoSelecionado != null && _comentarioController.text.isNotEmpty) {
                  Avaliacao novaAvaliacao = Avaliacao(
                    id: 0, // Será substituído pelo ID gerado no servidor
                    usuario_nome: widget.usuario.nome,
                    destino_id: _destinoSelecionado!.id!,
                    avaliacao: _comentarioController.text,
                  );

                  try {
                    //await Provider.of<AvaliacaoService>(context, listen: false).addAvaliacao(novaAvaliacao, _imagens);

                    setState(() {
                      _destinoSelecionado = null;
                      _comentarioController.clear();
                      _imagens.clear();
                    });

                    Navigator.of(context).pop();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Falha ao salvar a avaliação. Tente novamente.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
