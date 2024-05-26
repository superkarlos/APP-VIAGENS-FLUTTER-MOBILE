import 'package:My_App/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/components/destiny_grid.dart';
import 'package:My_App/components/drawer.dart';

import 'package:My_App/service/destino_service.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';

class TelaPrincipal extends StatelessWidget {
  final int userId;

  const TelaPrincipal({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    print("logado com o id $userId");
    final provider = Provider.of<DestinoService>(context);
    final providerUsuario = Provider.of<UsuarioService>(context);

    providerUsuario.fetchUsers();
    
    final List<Destino> destinations = provider.items;
    Usuario usuario = providerUsuario.findUserById(userId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Comprar Viagem',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Adicione aqui a lógica de sair do app
            },
          ),
        ],
      ),
      drawer: UsuarioDrawer(usuario: usuario),
      backgroundColor: Colors.deepPurple,
      body: DestinoGrid(),
    );
  }
}
