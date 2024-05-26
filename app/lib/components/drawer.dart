import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/service/usuario_service.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/utils/routes.dart';

class UsuarioDrawer extends StatelessWidget {
  final Usuario usuario;
  const UsuarioDrawer({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  '${usuario.nome}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Perfil'),
            onTap: () {
              // Adicione a lógica para navegar para a página de perfil
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              // Adicione a lógica para navegar para a página de configurações
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.MAIN_PAGE);
            },
          ),
        ],
      ),
    );
  }
}
