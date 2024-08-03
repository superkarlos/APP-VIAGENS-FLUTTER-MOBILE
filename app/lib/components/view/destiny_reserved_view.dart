import 'package:My_App/components/view/destiny_reserved_detail_view.dart';
import 'package:My_App/screens/tela_principal.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:My_App/components/view/base_destiny_view.dart';

class DestinyReservedView extends StatelessWidget {
  final Usuario usuario;

  const DestinyReservedView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final destiny = Provider.of<Destino>(context, listen: false);
    final destinyService = Provider.of<DestinoService>(context, listen: false);
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);

    return BaseDestinyView(
      destiny: destiny,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmar remoção'),
                  content: Text('Tem certeza de que deseja cancelar esta reserva?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        usuario.saldo += destiny.preco;
                        usuario.destinos.remove(destiny);
                        try {
                          await usuarioService.updateUser(usuario);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Reserva cancelada com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao cancelar reserva: $e'),
                              backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                            ),
                          );
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TelaPrincipal(userId: usuario.id),
                          ),
                        );
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
              child: DestinyReservedDetailPage(usuario: usuario),
            ),
          ),
        );
      },
    );
  }
}
