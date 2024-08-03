import 'package:flutter/material.dart';
import 'package:My_App/components/view/destino_edit_view.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/components/grid/base_destiny_grid.dart';


class DestinoGridEdit extends StatelessWidget {
  final Usuario usuario;

  const DestinoGridEdit({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDestinoGrid(
      usuario: usuario,
      itemBuilder: (ctx, destino) => DestinyEditView(usuario: usuario),
    );
  }
}
