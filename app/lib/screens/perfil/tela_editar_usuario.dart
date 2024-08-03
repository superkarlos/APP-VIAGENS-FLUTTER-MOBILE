import 'dart:io';

import 'package:My_App/screens/tela_principal.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TelaEditarUsuario extends StatefulWidget {
  final Usuario usuario;

  const TelaEditarUsuario({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaEditarUsuarioState createState() => _TelaEditarUsuarioState();
}

class _TelaEditarUsuarioState extends State<TelaEditarUsuario> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _imagemPerfil;

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.usuario.nome;
    _usuarioController.text = widget.usuario.usuario;
    _senhaController.text = widget.usuario.senha;
    _imagemPerfil = widget.usuario.imagemPerfil;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if(pickedFile != null){
      setState(() {
        _imagemPerfil = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imagemPerfil != null ? FileImage(File(_imagemPerfil!)) : AssetImage('assets/images/pngwing.com.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () async {
                            final action = await showDialog<ImageSource>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Selecionar imagem'),
                                content: Text('Escolha a origem da imagem:'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                                    child: Text('Câmera'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, ImageSource.gallery),
                                    child: Text('Galeria'),
                                  ),
                                ],
                              )
                            );
                            if(action != null){
                              await _pickImage(action);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _usuarioController,
                  decoration: InputDecoration(labelText: 'Usuário'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome de usuário';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a senha';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedUsuario = Usuario(
                          id: widget.usuario.id,
                          nome: _nomeController.text.isNotEmpty
                              ? _nomeController.text
                              : widget.usuario.nome,
                          usuario: _usuarioController.text.isNotEmpty
                              ? _usuarioController.text
                              : widget.usuario.usuario,
                          senha: _senhaController.text.isNotEmpty
                              ? _senhaController.text
                              : widget.usuario.senha,
                          saldo: widget.usuario.saldo,
                          destinos: widget.usuario.destinos,
                          fotos: widget.usuario.fotos,
                          imagemPerfil: _imagemPerfil,
                        );
                        await Provider.of<UsuarioService>(context,
                                listen: false)
                            .updateUser(updatedUsuario);
                        await Provider.of<UsuarioService>(context, listen: false)
                            .fetchUsers();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TelaPrincipal(userId: widget.usuario.id),
                          ),
                        );
                      }
                    },
                    child: Text('Salvar Alterações'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
