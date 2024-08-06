import 'package:My_App/screens/avaliacao/tela_adicionar_avaliacao.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/model/avaliacao.dart';
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
  final TextEditingController _comentarioController = TextEditingController();
  Destino? _destinoSelecionado;

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
                          if (avaliacao.foto_urls != null)
                            ...avaliacao.foto_urls!.map((url) => Image.network(url)),
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

  void _mostrarFormularioAvaliacao(BuildContext context, List<Destino> destinosDisponiveis) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deixe sua avaliação'),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<Destino>(
                  hint: const Text('Selecione o destino'),
                  value: _destinoSelecionado,
                  onChanged: (Destino? novoDestino) {
                    setState(() {
                      _destinoSelecionado = novoDestino;
                    });
                  },
                  items: destinosDisponiveis.map((destino) {
                    return DropdownMenuItem<Destino>(
                      value: destino,
                      child: Text(destino.nome),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _comentarioController,
                  decoration: const InputDecoration(labelText: 'Seu comentário'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_destinoSelecionado != null && _comentarioController.text.isNotEmpty) {
                  Avaliacao novaAvaliacao = Avaliacao(
                    id: 0, // Será substituído pelo ID gerado no servidor
                    usuarioId: widget.usuario.id,
                    usuario_nome: widget.usuario.nome,
                    destino_id: _destinoSelecionado!.id,
                    avaliacao: _comentarioController.text,
                  );

                  try {
                    await Provider.of<AvaliacaoService>(context, listen: false).addAvaliacao(context, novaAvaliacao);

                    setState(() {
                      _destinoSelecionado = null;
                      _comentarioController.clear();
                    });

                    Navigator.of(context).pop();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Falha ao salvar a avaliação. Tente novamente.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
