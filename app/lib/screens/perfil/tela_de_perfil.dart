import 'dart:io';

import 'package:My_App/screens/perfil/tela_de_deposito.dart';
import 'package:My_App/screens/perfil/tela_editar_usuario.dart';
import 'package:My_App/screens/tela_de_login.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/usuario.dart';
import 'package:provider/provider.dart';

class TelaDePerfil extends StatelessWidget {
  final Usuario usuario;

  const TelaDePerfil({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundImage: usuario.imagemPerfil != null
                    ? FileImage(File(usuario.imagemPerfil!))
                    : AssetImage('assets/images/pngwing.com.png') as ImageProvider,
              ),
              SizedBox(height: 16),
              Text(
                usuario.nome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Saldo: \$${usuario.saldo.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final novoSaldo = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TelaDepositoPage(usuario: usuario),
                    ),
                  );
                  if (novoSaldo != null) {
                    usuarioService.updateUser(usuario);
                  }
                },
                child: Text('Depositar Saldo'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final atualizado = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TelaEditarUsuario(usuario: usuario),
                    ),
                  );
                  if (atualizado == true) {
                    usuarioService.updateUser(usuario);
                  }
                },
                child: Text('Editar Informações'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  usuarioService.removeUser(usuario);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('Deletar Usuário'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
