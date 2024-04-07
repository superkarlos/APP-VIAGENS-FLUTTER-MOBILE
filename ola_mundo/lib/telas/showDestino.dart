import 'package:flutter/material.dart';
import 'package:ola_mundo/telas/listarViagensReservadas.dart';
import '../model/Destino.dart';
import '../main.dart';

class ShowDestino extends StatelessWidget {
  final Destino destino;
  final List<Destino> viagensReservadas;
  double saldoUsuario;
  final Function(double) updateSaldoCallback;

  ShowDestino({
    required this.destino,
    required this.viagensReservadas,
    required this.saldoUsuario,
    required this.updateSaldoCallback,
  });

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
            ElevatedButton(
              onPressed: () {
                reservarViagem(context, destino, viagensReservadas,
                    saldoUsuario, updateSaldoCallback);
              },
              child: Text('Reservar Viagem'),
            ),
          ],
        ),
      ),
    );
  }
}

/*bool _reservarViagem(
    Destino destino, List<Destino> viagensReservadas, double saldoUSuario) {
  if (saldoUSuario >= destino.preco) {
    //saldoUSuario = saldoUSuario - destino.preco;
    viagensReservadas.add(destino);
    return true;
  }
  return false;
}*/
void reservarViagem(
    BuildContext context,
    Destino destino,
    List<Destino> viagensReservadas,
    double saldoUsuario,
    Function(double) callback) {
  if (saldoUsuario >= destino.preco) {
    // Reduzir o saldo do usuário
    saldoUsuario -= destino.preco;

    // Adicionar o destino à lista de viagens reservadas
    viagensReservadas.add(destino);

    // Chamar o callback para atualizar o saldo
    callback(saldoUsuario);

    // Voltar para a tela anterior
    Navigator.pop(context, true);
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saldo Insuficiente'),
          content:
              Text('Você não tem saldo suficiente para reservar esta viagem.'),
          actions: FlatButton(
            child: Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}

FlatButton({required Text child, required Null Function() onPressed}) {}