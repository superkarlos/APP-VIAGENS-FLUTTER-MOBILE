import 'package:My_App/components/destiny_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destiny_list.dart';
import 'package:My_App/model/destiny.dart';

class HomePage extends StatelessWidget {

  void _sairDoApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DestinyList>(context);
    final List<Destiny> destinations = provider.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Cor personalizada para a AppBar
        title: const Text('Comprar Viagem'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _sairDoApp,
          ),
        ],
      ),
      body: DestinyGrid()
    );
  }
}
