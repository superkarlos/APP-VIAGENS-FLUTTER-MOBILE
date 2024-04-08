import 'package:flutter/material.dart';
import 'package:ola_mundo/model/Usuario.dart';

class TelaDepositoPage extends StatefulWidget {
  final Usuario usuario;

  TelaDepositoPage({required this.usuario});
  @override
  _TelaDepositoPageState createState() => _TelaDepositoPageState();
}

class _TelaDepositoPageState extends State<TelaDepositoPage> {
  double _valorDepositado = 0;

  void _depositarDinheiro(double valor) {
    setState(() {
      widget.usuario.saldo += valor;
    });

    Navigator.pop(context, widget.usuario.saldo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Depositar Dinheiro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione o valor a depositar:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Slider(
              value: _valorDepositado,
              min: 0,
              max: 10000,
              divisions: 100,
              label: 'R\$ ${_valorDepositado.toStringAsFixed(2)}',
              onChanged: (double value) {
                setState(() {
                  _valorDepositado = value;
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ou digite o valor:',
              ),
              onChanged: (value) {
                setState(() {
                  _valorDepositado = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _depositarDinheiro(_valorDepositado);
              },
              child: Text('Depositar'),
            ),
          ],
        ),
      ),
    );
  }
}