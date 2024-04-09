import 'package:flutter/material.dart';
import 'package:My_App/model/Avaliacao.dart';
import '../model/Destino.dart';

class ShowDestino extends StatelessWidget {
  final Destino destino;
  final List<Destino> viagensReservadas;
  final double saldoUsuario;
  final Function(double) updateSaldoCallback;
  final List<Avaliacao> avaliacoes;

  const ShowDestino({super.key, 
    required this.destino,
    required this.viagensReservadas,
    required this.saldoUsuario,
    required this.updateSaldoCallback,
    required this.avaliacoes,
  });

  @override
  Widget build(BuildContext context) {
    destino.calcularMediaDeNota(avaliacoes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Destino'),
        backgroundColor: const Color.fromARGB(255, 213, 231, 245),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      backgroundColor: const Color.fromARGB(255, 213, 231, 245),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  destino.nome,
                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    destino.url,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 193, 215, 233), // Cor de fundo mais escura
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Descrição do destino:',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        destino.descricao,
                        style: const TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Nota de Avaliaçoes: ${destino.mediaDeNota.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Preço da passagem: ${destino.preco}',
                  style: const TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    reservarViagem(context, destino, viagensReservadas,
                        saldoUsuario, updateSaldoCallback);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor de fundo do botão
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Cor do texto do botão
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Espaçamento interno
                    textStyle: const TextStyle(fontSize: 18.0), // Tamanho do texto do botão
                  ),
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
