import 'package:flutter/material.dart';
import '../model/Avaliacao.dart';
import 'tela_principal.dart';

class AvaliacaoPage extends StatefulWidget {
  final List<Avaliacao> avaliacoes;

  AvaliacaoPage({required this.avaliacoes});

  @override
  _AvaliacaoPageState createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _nomeDestinoController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações'),
      ),
      body: ListView.builder(
        itemCount: widget.avaliacoes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Local: ${widget.avaliacoes[index].nomeDestino}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TextField(
                  controller: _nomeDestinoController,
                  decoration: InputDecoration(labelText: 'Nome do local'),
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
                  decoration: InputDecoration(labelText: 'Sua nota (de 1 a 5)'),
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
                if (_nomeDestinoController.text.isNotEmpty &&
                    _nomeUsuarioController.text.isNotEmpty &&
                    _comentarioController.text.isNotEmpty &&
                    _notaController.text.isNotEmpty) {
                  // Convertendo a nota para int
                  int nota = int.tryParse(_notaController.text) ?? 0;

                  // Verificando se a nota está dentro do intervalo válido (de 1 a 5)
                  if (nota >= 1 && nota <= 5) {
                    // Criando uma nova avaliação
                    Avaliacao novaAvaliacao = Avaliacao(
                      nomeUsuario: _nomeUsuarioController.text,
                      textoComentario: _comentarioController.text,
                      nota: nota,
                      nomeDestino: _nomeDestinoController.text,
                    );

                    // Adicionando a nova avaliação à lista de avaliações
                    setState(() {
                      widget.avaliacoes.add(novaAvaliacao);
                    });

                    // Fechando o diálogo
                    Navigator.of(context).pop();
                  } else {
                    // Exibindo uma mensagem de erro se a nota não estiver no intervalo válido
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Por favor, insira uma nota válida de 1 a 5.'),
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
