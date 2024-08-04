import 'dart:io';

import 'package:My_App/screens/tela_principal.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:My_App/model/usuario.dart';
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
  String? _imagemPerfil;

  final FirebaseStorage storage = FirebaseStorage.instance;
  bool uploading = false;
  double total = 0;
  Reference? lastUploadedRef;
  String? lastUploadedImageUrl;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.usuario.nome;
    _usuarioController.text = widget.usuario.usuario;
    _senhaController.text = widget.usuario.senha;
    _imagemPerfil = widget.usuario.imagemPerfil;
    loadLastImage();
  }

  loadLastImage() async {
    var refs = (await storage.ref('profile-images/${widget.usuario.id}').listAll()).items;
    if (refs.isNotEmpty) {
      lastUploadedRef = refs.last;
      lastUploadedImageUrl = await lastUploadedRef!.getDownloadURL();
    }

    setState(() {
      loading = false;
    });
  }

  Future<XFile?> getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    return image;
  }

  Future<UploadTask> uploadImage(String path) async {
    File file = File(path);

    try {
      String ref = 'profile-images/${widget.usuario.id}/img-${DateTime.now().toString()}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage(ImageSource source) async {
    XFile? file = await getImage(source);
    if (file != null) {
      UploadTask task = await uploadImage(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          lastUploadedRef = snapshot.ref;
          lastUploadedImageUrl = await lastUploadedRef!.getDownloadURL();
          setState(() => uploading = false);
        }
      });
    }
  }

  deleteImage() async {
    if (lastUploadedRef != null) {
      await storage.ref(lastUploadedRef!.fullPath).delete();
      lastUploadedRef = null;
      lastUploadedImageUrl = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      appBar: AppBar(
        title: uploading
            ? Text('${total.round()}% enviado')
            : Text('Editar Usuário'),
        actions: [
          uploading
              ? const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () => pickAndUploadImage(ImageSource.camera),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () => pickAndUploadImage(ImageSource.gallery),
                    ),
                  ],
                ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child:
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage: lastUploadedImageUrl == null ? AssetImage('assets/images/pngwing.com.png') as ImageProvider : NetworkImage(lastUploadedImageUrl!),
                            ),
                          ),
                          SizedBox(height: 16),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: deleteImage,
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
                                    imagemPerfil: lastUploadedImageUrl,
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
    );
  }
}
