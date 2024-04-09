import 'package:flutter/material.dart';
import 'package:My_App/model/Usuario.dart';

class TelaDepositoPage extends StatefulWidget {
  final Usuario usuario;

  const TelaDepositoPage({super.key, required this.usuario});
  @override
  // ignore: library_private_types_in_public_api
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
        title: const Text('Depositar Dinheiro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione o valor a depositar:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
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
              decoration: const InputDecoration(
                labelText: 'Ou digite o valor:',
              ),
              onChanged: (value) {
                setState(() {
                  _valorDepositado = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _depositarDinheiro(_valorDepositado);
              },
              child: const Text('Depositar'),
            ),
          ],
        ),
      ),
    );
  }
}