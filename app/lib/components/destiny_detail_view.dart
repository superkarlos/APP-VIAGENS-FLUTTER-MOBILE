import 'package:My_App/model/usuario.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:My_App/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:My_App/model/destino.dart';

class DestinyDetailPage extends StatelessWidget {
  final Usuario usuario;
  const DestinyDetailPage({Key? key, required this.usuario}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final destino = Provider.of<Destino>(context);
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do Destino',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 160, 118, 235),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      backgroundColor: const Color.fromARGB(255, 160, 118, 235),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                destino.nome,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  destino.imagemUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 139, 102, 204), // Cor de fundo mais escura
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Descrição do destino:',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      destino.descricao,
                      style: const TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Preço da passagem: ${destino.preco}',
                style: const TextStyle(fontSize: 18.0),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (usuario.saldo >= destino.preco) {
                        usuario.saldo -= destino.preco;
                        usuario.destinos.add(destino);

                        try {
                          await usuarioService.updateUser(usuario);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Reserva feita com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao fazer reserva: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Saldo insuficiente!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 139, 102, 204), // Cor do texto
                    ),
                    child: Text('Reservar Viagem'),
                  ),
                  SizedBox(width: 50),
                  IconButton(
                    icon: Consumer<Destino>(
                      builder: (context, destiny, child) => Icon(
                        destiny.isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                    onPressed: () {
                      destino.toggleFavorite();
                      Provider.of<DestinoService>(context, listen: false).updateFavorites();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}