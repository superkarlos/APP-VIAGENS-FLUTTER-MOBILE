import 'package:My_App/model/Avaliacao.dart';

class Destino {
  String nome;
  double preco;
  String url;
  double mediaDeNota;
  String descricao;

  Destino(this.nome, this.preco, this.url, this.descricao) : mediaDeNota = 0;

  void calcularMediaDeNota(List<Avaliacao> avaliacoes) {
    if (avaliacoes.isNotEmpty) {
      double totalNotas = 0;
      int contador = 0;
      for (var avaliacao in avaliacoes) {
        if (avaliacao.nomeDestino == nome) {
          totalNotas += avaliacao.nota;
          contador++;
        }
      }
      if (contador > 0) {
        mediaDeNota = totalNotas / contador;
      }
    }
  }
}