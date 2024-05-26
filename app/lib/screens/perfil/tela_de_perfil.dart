import 'package:My_App/screens/perfil/tela_editar_usuario.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/usuario.dart';
import 'package:provider/provider.dart';

class TelaDePerfil extends StatelessWidget {
  final Usuario usuario;

  const TelaDePerfil({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/pngwing.com.png'),
              ),
              SizedBox(height: 16),
              Text(
                usuario.nome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Saldo: \$${usuario.saldo.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TelaEditarUsuario(usuario: usuario),
                    ),
                  );
                },
                child: Text('Editar Informações'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.green, // Define a cor do texto do botão
                  shape: RoundedRectangleBorder(
                    // Define a forma do botão
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12), // Define o padding do botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
