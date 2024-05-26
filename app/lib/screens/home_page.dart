import 'package:My_App/components/destiny_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:My_App/service/destino_service.dart';
import 'package:My_App/model/destino.dart';

class TelaPrincipal extends StatelessWidget {
  //final String userId;
  //const TelaPrincipal({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DestinoService>(context);
    final List<Destino> destinations = provider.items;

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
      backgroundColor: Colors.deepPurple,
      body: DestinoGrid()
    );
  }
}
