import 'package:flutter/material.dart';
import 'package:ola_mundo/model/Destino.dart';
import 'package:ola_mundo/model/Usuario.dart';
import 'package:ola_mundo/screens/tela_de_login.dart';
import 'package:ola_mundo/telas/cadastrarDestino.dart';
import 'package:ola_mundo/telas/listarViagensReservadas.dart';
import 'package:ola_mundo/telas/showDestino.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  TelaPrincipal(this.usuario);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<Destino> viagensReservadas = [];
  List<Destino> destinos = [];
  /*List<Map<String, dynamic>> _viagens = [
    {'destino': 'Paris', 'preço': 2000},
    {'destino': 'Tokyo', 'preço': 3000},
    {'destino': 'Japão', 'preço': 5000},
    {'destino': 'Brasil', 'preço': 3000},
    // Adicione mais viagens aqui
  ];*/

  void _reservarViagem(Destino viagem) {
    double precoViagem = viagem.preco;
    if (widget.usuario.saldo >= precoViagem) {
      setState(() {
        widget.usuario.saldo -= precoViagem.toInt();
        viagensReservadas.add(viagem);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Saldo Insuficiente'),
            content: Text(
                'Você não tem saldo suficiente para reservar esta viagem.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Fechar'),
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

  void _depositarDinheiro(int valor) {
    setState(() {
      widget.usuario.saldo += valor;
    });
  }

  void _sairDoApp() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _sairDoPerfil() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => TelaLogin()));
  }

  void atualizarSaldo(double novoSaldo) {
    setState(() {
      widget.usuario.saldo = novoSaldo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprar Viagem'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _sairDoApp,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.usuario.nome),
              accountEmail: Text('Idade: ${widget.usuario.idade}'),
            ),
            ListTile(
              title: Text('Saldo: ${widget.usuario.saldo}'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Depositar Dinheiro 100 reais'),
              onTap: () {
                _depositarDinheiro(
                    100); // Exemplo de depósito de 100 unidades monetárias
              },
            ),
            ListTile(
              title: Text('Viagens Reservadas'),
              onTap: () {
                //Navegar para a página que mostra as viagens reservadas
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViagensReservadasPage(
                        viagensReservadas: viagensReservadas),
                  ),
                );
                /*
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Viagens Reservadas'),
                      content: ListView.builder(
                        itemCount: _viagensReservadas.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_viagensReservadas[index].nome),
                          );
                        },
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Fechar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );*/
              },
            ),
            ListTile(
              title: Text('Cadastrar Destino'),
              onTap: () {
                //Navegar para a página CadastrarDestinoPage quando clicar em "Cadastrar Destino"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastrarDestinoPage(destinos: destinos),
                  ),
                ).then((novoDestino) {
                  if (novoDestino != null) {
                    setState(() {
                      // destinos.add(novoDestino);
                    });
                  }
                });
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: _sairDoPerfil,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: destinos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${destinos[index].nome}'),
            subtitle: Text('Preço: ${destinos[index].preco}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDestino(
                    destino: destinos[index],
                    viagensReservadas: viagensReservadas,
                    saldoUsuario: widget.usuario.saldo,
                    updateSaldoCallback: atualizarSaldo,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

FlatButton({required Text child, required Null Function() onPressed}) {}
