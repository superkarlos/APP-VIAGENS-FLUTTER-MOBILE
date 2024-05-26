/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:My_App/model/Destino.dart';
import 'package:My_App/service/destino_service.dart';

class TelaPrincipal extends StatelessWidget {
  final String userId;

  const TelaPrincipal({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DestinoService(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Comprar Viagem'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // Adicione aqui a lógica de sair do app
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // Aqui você pode adicionar itens do Drawer, conforme seu layout
            ],
          ),
        ),
        body: Consumer<DestinoService>(
          builder: (context, provider, child) {
            if (provider.destinos.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: provider.destinos.length,
                itemBuilder: (context, index) {
                  final destino = provider.destinos[index];
                  return Card(
                    child: ListTile(
                      title: Text(destino.nome),
                      subtitle: Text('Preço: ${destino.preco}'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(destino.url_foto),
                      ),
                      onTap: () {
                        // Adicione aqui a navegação para a página de detalhes do destino
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
*/