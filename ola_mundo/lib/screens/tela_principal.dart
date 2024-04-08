import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ola_mundo/model/Destino.dart';
import 'package:ola_mundo/model/Usuario.dart';
import 'package:ola_mundo/screens/tela_de_login.dart';
import 'package:ola_mundo/screens/tela_de_cadastro_destinos.dart';
import 'package:ola_mundo/screens/tela_deposito.dart';
import 'package:ola_mundo/screens/tela_viagens_reservadas.dart';
import 'package:ola_mundo/screens/show_destino.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  TelaPrincipal(this.usuario);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<Destino> viagensReservadas = [];
  List<Destino> destinos = [];

  void initState() {
    super.initState();
    _adicionarDestinosPadrao();
  }

  void _adicionarDestinosPadrao() {
    destinos.add(Destino('Paris', 5000, 'https://www.segueviagem.com.br/wp-content/uploads/2016/08/Paris-Franca-shutterstock_1829492048-1000x675.jpg'));
    destinos.add(Destino('Tokyo', 3000, 'https://imgmd.net/images/v1/guia/1684253/tokyo-japao-199-c.jpg'));
    destinos.add(Destino('Xangai', 3500, 'https://viajologoexisto.com.br/wp-content/uploads/2018/01/O62A9823.jpg'));
    destinos.add(Destino('Rio De Janeiro', 1500, 'https://a.cdn-hotels.com/gdcs/production165/d100/5e0a7326-4dd3-40cc-9eb7-3af978f69b3d.jpg?impolicy=fcrop&w=800&h=533&q=medium'));
  }
  
  void _reservarViagem(Destino viagem) {
    double precoViagem = viagem.preco;
    if (widget.usuario.saldo >= precoViagem) {
      setState(() {
        widget.usuario.saldo -= precoViagem.toDouble();
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

  Future<void> _depositarDinheiro(BuildContext context, Usuario usuario) async {
    final novoSaldo = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDepositoPage(usuario: usuario),
      ),
    );

    if (novoSaldo != null) {
    setState(() {
      usuario.saldo = novoSaldo;
    });
    }
  }

  void _sairDoApp() {
    SystemNavigator.pop();
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
              title: Text('Depositar Dinheiro'),
              onTap: () {
                _depositarDinheiro(context, widget.usuario);
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
