import 'package:flutter/material.dart';
import '../model/Destino.dart';

class CadastrarDestinoPage extends StatefulWidget {
  // Declaração da lista de destinos
  final List<Destino> destinos;

  const CadastrarDestinoPage({super.key, required this.destinos});

  @override
  // ignore: library_private_types_in_public_api
  _CadastrarDestinoPageState createState() => _CadastrarDestinoPageState();
}

class _CadastrarDestinoPageState extends State<CadastrarDestinoPage> {
  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Destino'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do destino',
              ),
            ),
            TextField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL da imagem',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nomeController.text.isNotEmpty &&
                    _precoController.text.isNotEmpty && _descricaoController.text.isNotEmpty) {
                  // Criando um novo destino com os dados fornecidos
                  Destino novoDestino = Destino(_nomeController.text,
                      double.parse(_precoController.text), _urlController.text, _descricaoController.text);

                  // Adicionando o novo destino à lista de destinos no main.dart
                  widget.destinos.add(novoDestino);

                  // Fechando a página atual
                  Navigator.of(context).pop(novoDestino);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Erro'),
                          content: const Text('Por favor, preencha todos os campos.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                }
              },
              child: const Text('Salvar'),
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
    _descricaoController.dispose();
    super.dispose();
  }
}
