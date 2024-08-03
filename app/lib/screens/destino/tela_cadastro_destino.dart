import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:provider/provider.dart';

class TelaCadastroDestino extends StatefulWidget {
  @override
  _TelaCadastroDestinoState createState() => _TelaCadastroDestinoState();
}

class _TelaCadastroDestinoState extends State<TelaCadastroDestino> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _imagemUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Destino'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do destino';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _precoController,
                  decoration: InputDecoration(
                    labelText: 'Preço',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o preço';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _imagemUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL da Imagem',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a URL da imagem';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final novoDestino = Destino(
                          id: 0,
                          nome: _nomeController.text,
                          descricao: _descricaoController.text,
                          preco: double.parse(_precoController.text),
                          imagemUrl: _imagemUrlController.text,
                        );
                        Provider.of<DestinoService>(context, listen: false)
                            .addDestino(novoDestino);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






/*import 'package:My_App/model/destino.dart';
import 'package:flutter/material.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:provider/provider.dart';

class TelaCadastroDestino extends StatefulWidget {
  @override
  _TelaCadastroDestinoState createState() => _TelaCadastroDestinoState();
}

class _TelaCadastroDestinoState extends State<TelaCadastroDestino> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _imagemUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Destino'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome do destino';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _precoController,
                  decoration: InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o preço';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imagemUrlController,
                  decoration: InputDecoration(labelText: 'URL da Imagem'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a URL da imagem';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final novoDestino = Destino(
                          id: 0,
                          nome: _nomeController.text,
                          descricao: _descricaoController.text,
                          preco: double.parse(_precoController.text),
                          imagemUrl: _imagemUrlController.text,
                          isFavorite: false,
                        );
                        Provider.of<DestinoService>(context, listen: false)
                            .addDestino(novoDestino);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/