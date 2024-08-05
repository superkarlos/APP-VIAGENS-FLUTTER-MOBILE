import 'package:flutter/material.dart';
import 'package:My_App/components/view/destiny_view.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/components/grid/base_destiny_grid.dart';


class DestinoGrid extends StatelessWidget {
  final Usuario usuario;

  const DestinoGrid({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return BaseDestinoGrid(
      usuario: usuario,
      itemBuilder: (ctx, destino) => DestinyView(usuario: usuario),
    );
  }
}
