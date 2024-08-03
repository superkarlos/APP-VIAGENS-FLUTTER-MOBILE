import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/components/view/base_destiny_view.dart';
import 'package:My_App/components/view/destiny_detail_view.dart';

class DestinyView extends StatelessWidget {
  final Usuario usuario;

  const DestinyView({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final destiny = Provider.of<Destino>(context, listen: false);

    return BaseDestinyView(
      destiny: destiny,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: destiny,
              child: DestinyDetailPage(usuario: usuario),
            ),
          ),
        );
      },
    );
  }
}
