import 'package:flutter/material.dart';
import '../main.dart';
import '../model/Destino.dart';

class ViagensReservadasPage extends StatefulWidget {
  final List<Destino> viagensReservadas;

  ViagensReservadasPage({required this.viagensReservadas});

  @override
  _ViagensReservadasPageState createState() => _ViagensReservadasPageState();
}

class _ViagensReservadasPageState extends State<ViagensReservadasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viagens Reservadas'),
      ),
      body: ListView.builder(
        itemCount: widget.viagensReservadas.length,
        itemBuilder: (context, index) {
          final viagem = widget.viagensReservadas[index];
          return ListTile(
            title: Text(viagem.nome),
            trailing: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                _cancelarViagem(viagem);
              },
            ),
          );
        },
      ),
    );
  }

  void _cancelarViagem(Destino viagem) {
    setState(() {
      widget.viagensReservadas.remove(viagem);
    });
  }
}