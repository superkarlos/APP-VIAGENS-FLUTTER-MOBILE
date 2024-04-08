import 'package:flutter/material.dart';
import '../model/Destino.dart';
import '../main.dart';

class CadastrarDestinoPage extends StatefulWidget {
  // Declaração da lista de destinos
  final List<Destino> destinos;

  CadastrarDestinoPage({required this.destinos});

  @override
  _CadastrarDestinoPageState createState() => _CadastrarDestinoPageState();
}

class _CadastrarDestinoPageState extends State<CadastrarDestinoPage> {
  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Destino'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do destino',
              ),
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(
                labelText: 'Preço',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL da imagem',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!_nomeController.text.isEmpty &&
                    !_precoController.text.isEmpty) {
                  // Criando um novo destino com os dados fornecidos
                  Destino novoDestino = Destino(_nomeController.text,
                      double.parse(_precoController.text), _urlController.text);

                  // Adicionando o novo destino à lista de destinos no main.dart
                  widget.destinos.add(novoDestino);

                  // Fechando a página atual
                  Navigator.of(context).pop(novoDestino);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Erro'),
                          content: Text('Por favor, preencha todos os campos.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose dos controladores quando a página for descartada
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }
}
