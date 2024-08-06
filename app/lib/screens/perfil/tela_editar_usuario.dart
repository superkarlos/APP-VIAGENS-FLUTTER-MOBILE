import 'package:My_App/screens/tela_principal.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:My_App/model/usuario.dart';
import 'package:provider/provider.dart';

class TelaEditarUsuario extends StatefulWidget {
  final Usuario usuario;

  const TelaEditarUsuario({super.key, required this.usuario});

  @override
  _TelaEditarUsuarioState createState() => _TelaEditarUsuarioState();
}

class _TelaEditarUsuarioState extends State<TelaEditarUsuario> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.usuario.nome;
    _usuarioController.text = widget.usuario.usuario;
    _senhaController.text = widget.usuario.senha;

    Provider.of<UsuarioService>(context, listen: false)
        .loadLastImage(widget.usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          usuarioService.uploading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
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
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => usuarioService.pickAndUploadImage(
                          ImageSource.camera, widget.usuario.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () => usuarioService.pickAndUploadImage(
                          ImageSource.gallery, widget.usuario.id),
                    ),
                  ],
                ),
        ],
      ),
      body: usuarioService.loadingImage
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: usuarioService.lastUploadedImageUrl == null
                            ? const AssetImage('assets/images/pngwing.com.png') as ImageProvider
                            : NetworkImage(usuarioService.lastUploadedImageUrl!),
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: usuarioService.deleteImage,
                    ),
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira o nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(labelText: 'Usuário'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira o nome de usuário';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira a senha';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                              imagemPerfil: usuarioService.lastUploadedImageUrl,
                            );
                            await usuarioService.updateUser(updatedUsuario);
                            await usuarioService.fetchUsers();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TelaPrincipal(userId: widget.usuario.id),
                              ),
                            );
                          }
                        },
                        child: const Text('Salvar Alterações'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
