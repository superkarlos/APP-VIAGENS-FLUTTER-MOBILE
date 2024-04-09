import 'package:flutter/material.dart';
import 'package:My_App/model/Destino.dart';

import '../model/Avaliacao.dart';

class AvaliacaoPage extends StatefulWidget {
  final List<Avaliacao> avaliacoes;
  final List<Destino> destinosDisponiveis; // Adiciona a lista de destinos disponíveis

  AvaliacaoPage({required this.avaliacoes, required this.destinosDisponiveis});

  @override
  _AvaliacaoPageState createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  Destino? _destinoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
      body: ListView.builder(
        itemCount: widget.avaliacoes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Local: ${widget.avaliacoes[index].nomeDestino}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuário: ${widget.avaliacoes[index].nomeUsuario}'),
                Text('Comentário: ${widget.avaliacoes[index].textoComentario}'),
                Text('Nota: ${widget.avaliacoes[index].nota}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormularioAvaliacao(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormularioAvaliacao(BuildContext context) {
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
                  items: widget.destinosDisponiveis.map((destino) {
                    return DropdownMenuItem<Destino>(
                      value: destino,
                      child: Text(destino.nome),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _nomeUsuarioController,
                  decoration: InputDecoration(labelText: 'Seu nome'),
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
              onPressed: () {
                // Verificando se todos os campos estão preenchidos
                if (_destinoSelecionado != null &&
                    _nomeUsuarioController.text.isNotEmpty &&
                    _comentarioController.text.isNotEmpty &&
                    _notaController.text.isNotEmpty) {
                  // Convertendo a nota para int
                  double nota = double.tryParse(_notaController.text) ?? 0;

                  // Verificando se a nota está dentro do intervalo válido (de 1 a 5)
                  if (nota >= 0 && nota <= 5) {
                    // Criando uma nova avaliação
                    Avaliacao novaAvaliacao = Avaliacao(
                      nomeUsuario: _nomeUsuarioController.text,
                      textoComentario: _comentarioController.text,
                      nota: nota,
                      nomeDestino: _destinoSelecionado!.nome,
                    );

                    // Adicionando a nova avaliação à lista de avaliações
                    setState(() {
                      widget.avaliacoes.add(novaAvaliacao);
                      _destinoSelecionado = null;
                      _nomeUsuarioController.text = '';
                      _comentarioController.text = '';
                      _notaController.text = '';
                    });

                    // Fechando o diálogo
                    Navigator.of(context).pop();
                  } else {
                    // Exibindo uma mensagem de erro se a nota não estiver no intervalo válido
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Por favor, insira uma nota válida de 0 a 5.'),
                      ),
                    );
                  }
                } else {
                  // Exibindo uma mensagem de erro se algum campo estiver vazio
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