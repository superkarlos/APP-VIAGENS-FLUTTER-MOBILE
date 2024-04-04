import 'package:flutter/material.dart';
import '../model/Destino.dart';
import '../main.dart';

class ShowDestino extends StatelessWidget {
  final Destino destino;

  ShowDestino({required this.destino});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Destino'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nome do destino: ${destino.nome}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Preço da passagem: ${destino.preco}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
