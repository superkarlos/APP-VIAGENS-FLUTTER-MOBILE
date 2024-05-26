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
          _criarDrawerItem(
            icon: Icons.account_circle,
            text: 'Perfil',
            onTap: (){},
          ),
          _criarDrawerItem(
              icon: Icons.monetization_on_outlined,
              text: 'Depositar Dinheiro',
              onTap: () {},
          ),
          _criarDrawerItem(
            icon: Icons.card_travel,
            text: 'Viagens Reservadas',
            onTap: () {},
          ),
          _criarDrawerItem(
            icon: Icons.add_location,
            text: 'Cadastrar Destino',
            onTap: () {},
          ),
          _criarDrawerItem(
            icon: Icons.comment,
            text: 'Fazer avaliação',
            onTap: () {},
          ),
          _criarDrawerItem(
            icon: Icons.image,
            text: 'Upload de fotos',
            onTap: () {},
          ),
          _criarDrawerItem(
            icon: Icons.settings,
            text: 'Configurações',
            onTap: (){},
          ),
          _criarDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Sair',
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.MAIN_PAGE);
            },
          ),
        ],
      ),
    );
  }
}

Widget _criarDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onTap,
  );
}