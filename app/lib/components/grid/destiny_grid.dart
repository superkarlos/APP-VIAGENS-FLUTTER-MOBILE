import 'package:flutter/material.dart';
import 'package:My_App/components/view/destiny_view.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/components/grid/base_destiny_grid.dart';


class DestinoGrid extends StatelessWidget {
  final Usuario usuario;

  const DestinoGrid({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDestinoGrid(
      usuario: usuario,
      itemBuilder: (ctx, destino) => DestinyView(usuario: usuario),
    );
  }
}
