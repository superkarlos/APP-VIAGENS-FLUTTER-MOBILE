import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:My_App/components/view/base_destiny_view.dart';
import 'package:My_App/components/view/destiny_detail_view.dart';
import 'package:My_App/screens/destino/edicao_destino.dart';

class DestinyEditView extends StatelessWidget {
  final Usuario usuario;

  const DestinyEditView({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final destiny = Provider.of<Destino>(context, listen: false);
    final destinyService = Provider.of<DestinoService>(context, listen: false);

    return BaseDestinyView(
      destiny: destiny,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EdicaoDestino(destino: destiny, usuario: usuario),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Mostrar um diálogo de confirmação
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar remoção'),
                  content: Text('Tem certeza de que deseja remover este local?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        destinyService.removeDestiny(destiny);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Local removido')),
                        );
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                      child: Text('Remover'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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