import 'package:flutter/material.dart';
import '../model/Foto.dart';
import 'tela_principal.dart';

class FotoPage extends StatefulWidget {
  final List<Foto> fotos;

  FotoPage({required this.fotos});

  @override
  _FotoPageState createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  final TextEditingController _urlFotoController = TextEditingController();
  final TextEditingController _descricaoFotoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos'),
      ),
      body: ListView.builder(
        itemCount: widget.fotos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.fotos[index].descricao),
            leading: Image.network(
              widget.fotos[index].url,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormularioFoto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormularioFoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Foto'),
          content: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _urlFotoController,
                  decoration: InputDecoration(labelText: 'URL da foto'),
                ),
                TextField(
                  controller: _descricaoFotoController,
                  decoration: InputDecoration(labelText: 'Descrição da foto'),
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
                if (_urlFotoController.text.isNotEmpty &&
                    _descricaoFotoController.text.isNotEmpty) {
                  // Criando uma nova foto
                  Foto novaFoto = Foto(
                    _urlFotoController.text,
                    _descricaoFotoController.text,
                  );

                  // Adicionando a nova foto à lista de fotos
                  setState(() {
                    widget.fotos.add(novaFoto);
                  });

                  // Fechando o diálogo
                  Navigator.of(context).pop();
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
