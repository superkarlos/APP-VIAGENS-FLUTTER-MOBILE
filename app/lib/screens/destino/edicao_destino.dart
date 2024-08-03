import 'package:My_App/model/usuario.dart';
import 'package:My_App/screens/tela_principal.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/service/destino_service.dart';
import 'package:provider/provider.dart';

class EdicaoDestino extends StatefulWidget {
  final Destino destino;
  final Usuario usuario;

  const EdicaoDestino({Key? key, required this.destino, required this.usuario})
      : super(key: key);

  @override
  _EdicaoDestinoState createState() => _EdicaoDestinoState();
}

class _EdicaoDestinoState extends State<EdicaoDestino> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _imagemUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.destino.nome;
    _descricaoController.text = widget.destino.descricao;
    _precoController.text = widget.destino.preco.toString();
    _imagemUrlController.text = widget.destino.imagemUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Destino'),
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
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira a descrição';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _precoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Preço'),
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedDestino = Destino(
                          id: widget.destino.id,
                          nome: _nomeController.text.isNotEmpty
                              ? _nomeController.text
                              : widget.destino.nome,
                          descricao: _descricaoController.text.isNotEmpty
                              ? _descricaoController.text
                              : widget.destino.descricao,
                          preco: double.tryParse(_precoController.text) ??
                              widget.destino.preco,
                          imagemUrl: _imagemUrlController.text.isNotEmpty
                              ? _imagemUrlController.text
                              : widget.destino.imagemUrl,
                        );
                        await Provider.of<DestinoService>(context,
                                listen: false)
                            .updateDestiny(updatedDestino);
                        await Provider.of<DestinoService>(context,
                                listen: false)
                            .fetchDestinos();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                TelaPrincipal(userId: widget.usuario.id),
                          ),
                        );
                      }
                    },
                    child: Text('Salvar Alterações'),
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
