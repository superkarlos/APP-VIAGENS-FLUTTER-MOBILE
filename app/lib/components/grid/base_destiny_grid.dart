import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/service/destino_service.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';

class BaseDestinoGrid extends StatelessWidget {
  final Usuario usuario;
  final Widget Function(BuildContext, Destino) itemBuilder;

  const BaseDestinoGrid({
    Key? key,
    required this.usuario,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DestinoService>(context);

    final List<Destino> loadedDestinations = provider.items;

    return ValueListenableBuilder(
      valueListenable: provider.updateNotifier,
      builder: (ctx, value, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedDestinations.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: loadedDestinations[i],
            child: itemBuilder(ctx, loadedDestinations[i]),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        );
      },
    );
  }
}
