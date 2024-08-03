import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/components/view/destiny_reserved_view.dart';

class DestinosReservadosGrid extends StatelessWidget {
  final Usuario usuario;

  const DestinosReservadosGrid({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenha a lista de destinos reservados do usuário
    final List<Destino> reservedDestinations = usuario.destinos;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: reservedDestinations.length,
      itemBuilder: (ctx, i) {
        final destino = reservedDestinations[i];
        return ChangeNotifierProvider.value(
          value: destino,
          child: DestinyReservedView(usuario: usuario),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // 1 produto por linha
        childAspectRatio: 2 / 1, // Dimensão de cada elemento
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
