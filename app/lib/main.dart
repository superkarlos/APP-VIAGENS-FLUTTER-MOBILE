import 'package:My_App/screens/destino/destiny_detail_page.dart';
import 'package:My_App/screens/tela_principal.dart';
import 'package:My_App/screens/tela_de_cadastro.dart';
import 'package:My_App/screens/tela_de_login.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:My_App/service/usuario_service.dart'; // Importe o UsuarioService
import 'package:My_App/utils/routes.dart';
import 'package:flutter/material.dart';
import 'firebase_option.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DestinoService()),
        ChangeNotifierProvider(
            create: (ctx) => UsuarioService()), // Adicione o UsuarioService
      ],
      child: MaterialApp(
        title: 'App de Viagens',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
        routes: {
          AppRoutes.DESTINY_DETAIL: (context) => const DestinyDetailPage(),
          AppRoutes.MAIN_PAGE: (context) => LoginPage(),
          AppRoutes.CADASTRO: (context) => const TelaCadastro(),
        },
      ),
    );
  }
}
