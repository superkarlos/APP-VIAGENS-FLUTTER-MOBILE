import 'package:My_App/screens/destino/destiny_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/utils/routes.dart';

class DestinyView extends StatelessWidget {
  final Usuario usuario;
  const DestinyView({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final destiny = Provider.of<Destino>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            destiny.imagemUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: destiny, // Aqui você passa a instância de Destino
                  child: DestinyDetailPage(usuario: usuario,),
                ),
              ),
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Color.fromARGB(221, 58, 7, 82),
          title: Text(
            destiny.nome,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
