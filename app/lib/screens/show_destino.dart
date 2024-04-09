import 'package:flutter/material.dart';
import '../model/Destino.dart';

class ShowDestino extends StatelessWidget {
  final Destino destino;
  final List<Destino> viagensReservadas;
  final double saldoUsuario;
  final Function(double) updateSaldoCallback;

  const ShowDestino({super.key, 
    required this.destino,
    required this.viagensReservadas,
    required this.saldoUsuario,
    required this.updateSaldoCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Destino'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  destino.url,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Nome do destino: ${destino.nome}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Preço da passagem: ${destino.preco}',
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  reservarViagem(context, destino, viagensReservadas,
                      saldoUsuario, updateSaldoCallback);
                },
                child: const Text('Reservar Viagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          title: const Text('Saldo Insuficiente'),
          content:
              const Text('Você não tem saldo suficiente para reservar esta viagem.'),
          actions: [
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
