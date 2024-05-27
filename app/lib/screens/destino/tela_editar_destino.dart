import 'package:My_App/components/destino_grid_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/service/destino_service.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';

class TelaEditarDestino extends StatelessWidget {
  final Usuario usuario;

  const TelaEditarDestino({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerDestino = Provider.of<DestinoService>(context);
    final List<Destino> destinations = providerDestino.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Destinos Cadastradas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: DestinoGridEdit(usuario: usuario,),
    );
  }
}
