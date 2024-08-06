import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/model/avaliacao.dart';
import '../../service/avaliacao_service.dart';
import '../../service/destino_service.dart';
import '../../service/usuario_service.dart';
import 'package:provider/provider.dart';

class FormularioAvaliacaoPage extends StatefulWidget {
  final Usuario usuario;
  final List<Destino> destinosDisponiveis;

  const FormularioAvaliacaoPage({super.key, required this.usuario, required this.destinosDisponiveis});

  @override
  _FormularioAvaliacaoPageState createState() => _FormularioAvaliacaoPageState();
}

class _FormularioAvaliacaoPageState extends State<FormularioAvaliacaoPage> {
  final TextEditingController _comentarioController = TextEditingController();
  Destino? _destinoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deixe sua avaliação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                items: widget.destinosDisponiveis.map((destino) {
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
              const SizedBox(height: 20),
              ElevatedButton(
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
          ),
        ),
      ),
    );
  }
}