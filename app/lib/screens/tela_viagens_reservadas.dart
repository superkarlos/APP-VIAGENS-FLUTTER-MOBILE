import 'package:flutter/material.dart';
import 'package:My_App/model/Usuario.dart';
import 'package:My_App/model/Destino.dart';

class ViagensReservadasPage extends StatefulWidget {
  final Usuario usuario;
  final List<Destino> viagensReservadas;
  final Function(double) updateSaldoCallback;

  const ViagensReservadasPage({super.key, 
    required this.usuario,
    required this.viagensReservadas,
    required this.updateSaldoCallback
    });

  @override
  // ignore: library_private_types_in_public_api
  _ViagensReservadasPageState createState() => _ViagensReservadasPageState();
}

class _ViagensReservadasPageState extends State<ViagensReservadasPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viagens Reservadas'),
      ),
      body: ListView.builder(
        itemCount: widget.viagensReservadas.length,
        itemBuilder: (context, index) {
          final viagem = widget.viagensReservadas[index];
          return ListTile(
            title: Text(viagem.nome),
            trailing: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                _cancelarViagem(viagem, viagem.preco);
              },
            ),
          );
        },
      ),
    );
  }

  void _cancelarViagem(Destino viagem, double saldo) {
    setState(() {
      widget.viagensReservadas.remove(viagem);
      widget.usuario.saldo += saldo;
    });

    widget.updateSaldoCallback(widget.usuario.saldo);
  }
}