import 'package:My_App/screens/avaliacao/tela_adicionar_avaliacao.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/usuario.dart';
import '../../service/avaliacao_service.dart';
import '../../service/destino_service.dart';
import '../../service/usuario_service.dart';
import 'package:provider/provider.dart';

class AvaliacaoPage extends StatefulWidget {
  final Usuario usuario;

  const AvaliacaoPage({super.key, required this.usuario});

  @override
  _AvaliacaoPageState createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {

  @override
  void initState() {
    super.initState();
    Provider.of<UsuarioService>(context, listen: false).fetchUsers();
    Provider.of<DestinoService>(context, listen: false).fetchDestinos();
    Provider.of<AvaliacaoService>(context, listen: false).fetchAvaliacoes();
  }

  @override
  Widget build(BuildContext context) {
    final destinosDisponiveis = Provider.of<DestinoService>(context).items;
    destinosDisponiveis.sort((a, b) => a.nome.compareTo(b.nome));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
      body: ListView.builder(
        itemCount: destinosDisponiveis.length,
        itemBuilder: (context, index) {
          final destino = destinosDisponiveis[index];
          final avaliacoes = destino.avaliacoes;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
              title: Text(
                destino.nome,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              children: avaliacoes.map((avaliacao) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('Usuário: ${avaliacao.usuario_nome}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comentário: ${avaliacao.avaliacao}'),
                          if (avaliacao.foto_urls != null && avaliacao.foto_urls!.isNotEmpty)
                            Container(
                              height: 200, // Ajuste a altura total do grid
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemCount: avaliacao.foto_urls!.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    avaliacao.foto_urls![index],
                                    fit: BoxFit.cover,
                                    height: 100, // Ajuste a altura das imagens
                                    width: 100,  // Ajuste a largura das imagens
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioAvaliacaoPage(usuario: widget.usuario, destinosDisponiveis: destinosDisponiveis))
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
