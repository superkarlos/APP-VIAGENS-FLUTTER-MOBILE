import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/model/avaliacao.dart';
import '../../service/avaliacao_service.dart';
import '../../service/destino_service.dart';
import 'package:provider/provider.dart';

class AvaliacaoPage extends StatefulWidget {
  final Usuario usuario;

  AvaliacaoPage({required this.usuario});

  @override
  _AvaliacaoPageState createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  Destino? _destinoSelecionado;

  @override
  Widget build(BuildContext context) {
    final avaliacoes = Provider.of<AvaliacaoService>(context).avaliacoes;
    final destinosDisponiveis = Provider.of<DestinoService>(context).destinos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
      body: ListView.builder(
        itemCount: avaliacoes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Local: ${destinosDisponiveis.firstWhere((destino) => destino.id == avaliacoes[index].destino_id).nome}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuário: ${avaliacoes[index].usuario_id}'),
                Text('Comentário: ${avaliacoes[index].avaliacao}'),
                // Text('Nota: ${avaliacoes[index].nota}'), // Adicione essa linha se a avaliação tiver uma nota
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormularioAvaliacao(context, destinosDisponiveis);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormularioAvaliacao(BuildContext context, List<Destino> destinosDisponiveis) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deixe sua avaliação'),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<Destino>(
                  hint: Text('Selecione o destino'),
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
                  decoration: InputDecoration(labelText: 'Seu comentário'),
                ),
                TextField(
                  controller: _notaController,
                  decoration: InputDecoration(labelText: 'Sua nota (de 0 a 5)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_destinoSelecionado != null &&
                    _comentarioController.text.isNotEmpty &&
                    _notaController.text.isNotEmpty) {
                  double nota = double.tryParse(_notaController.text) ?? 0;

                  if (nota >= 0 && nota <= 5) {
                    Avaliacao novaAvaliacao = Avaliacao(
                      id: 0, // Será substituído pelo ID gerado no servidor
                      usuario_id: widget.usuario.id,
                      destino_id: _destinoSelecionado!.id!,
                      avaliacao: _comentarioController.text,
                    //  nota: nota, // Adicionando a nota à avaliação
                    );

                    try {
                      await Provider.of<AvaliacaoService>(context, listen: false).addAvaliacao(novaAvaliacao);

                      setState(() {
                        Provider.of<AvaliacaoService>(context, listen: false).avaliacoes.add(novaAvaliacao);
                        _destinoSelecionado = null;
                        _comentarioController.text = '';
                        _notaController.text = '';
                      });

                      Navigator.of(context).pop();
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Falha ao salvar a avaliação. Tente novamente.'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, insira uma nota válida de 0 a 5.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
