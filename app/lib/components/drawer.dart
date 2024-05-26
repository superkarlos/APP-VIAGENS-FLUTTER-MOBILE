import 'package:My_App/utils/routes.dart';
import 'package:flutter/material.dart';

class UsuarioDrawer extends StatelessWidget {
  final int userId;

  const UsuarioDrawer({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Bem-vindo, Usuário $userId',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
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
