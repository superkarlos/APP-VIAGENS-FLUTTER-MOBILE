import 'package:flutter/material.dart';

import 'package:My_App/screens/home_page.dart';
import 'package:provider/provider.dart';

import 'package:My_App/provider/destiny_list.dart';

//import 'package:My_App/screens/tela_de_cadastro.dart';
//import 'package:My_App/screens/tela_de_login.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DestinyList(),
      child: MaterialApp(
        title: 'App de Viagens',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {
          //AppRoutes.MAINPAGE: (context) => const MeuApp(),
          //AppRoutes.CADASTRO: (context) => const TelaCadastro(),
        },
      ),
    );
  }
}