import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/usuario.dart';
import 'package:My_App/model/avaliacao.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/avaliacao_service.dart';
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
    final avaliacaoService = Provider.of<AvaliacaoService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deixe sua avaliação'),
        actions: [
          avaliacaoService.uploading
          ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => avaliacaoService.pickAndUploadImage(
                      ImageSource.camera),
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () => avaliacaoService.pickAndUploadImage(
                      ImageSource.gallery),
                ),
              ],
            ),
        ],
      ),
      body:
      avaliacaoService.loadingImage
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField<Destino>(
                  decoration: InputDecoration(
                    labelText: 'Selecione o destino',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.purple[50],
                  ),
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
                const SizedBox(height: 20),
                TextField(
                  controller: _comentarioController,
                  decoration: InputDecoration(
                    labelText: 'Seu comentário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.purple[50], // Cor de fundo roxo claro
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: avaliacaoService.arquivos.isEmpty
                      ? const Center(child: Text('Não há imagens ainda.'))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: avaliacaoService.arquivos.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    avaliacaoService.arquivos[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Provider.of<AvaliacaoService>(context, listen: false).deleteImage(index);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
                        foto_urls: avaliacaoService.arquivos, // Adiciona as URLs das fotos na avaliação
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        )
    );
  }
}
