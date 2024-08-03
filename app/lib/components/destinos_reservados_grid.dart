import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/service/destino_service.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';

import 'package:My_App/components/view/destiny_view.dart';

class DestinosReservadosGrid extends StatelessWidget {
  final Usuario usuario;
  const DestinosReservadosGrid({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DestinoService>(context);

    final List<Destino> loadedDestinations = usuario.destinos;

    return ValueListenableBuilder(
      valueListenable: provider.updateNotifier,
      builder: (ctx, value, _) {
        final List<Destino> loadedDestinations = usuario.destinos;
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedDestinations.length,
          //# ProductItem vai receber a partir do Provider
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            //create: (ctx) => Product(),
            value: loadedDestinations[i],
            //child: ProductItem(product: loadedDestinations[i]),
            child: DestinyView(usuario: usuario,),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, //2 produtos por linha
            childAspectRatio: 2 / 1, //diemnsao de cada elemento
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        );
      },
    );
  }
}
