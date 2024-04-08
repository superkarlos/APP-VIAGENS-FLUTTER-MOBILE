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

  @override
  void initState() {
    super.initState();
    _adicionarDestinosPadrao();
  }

  void _adicionarDestinosPadrao() {
    // Adiciona destinos padrão à lista
    // Substitua os links por imagens válidas de cada destino
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TelaLogin()));
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
        backgroundColor: Colors.deepPurple, // Cor personalizada para a AppBar
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
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent, // Cor de fundo para o cabeçalho do Drawer
              ),
              accountName: Text(widget.usuario.nome),
              accountEmail: Text('Idade: ${widget.usuario.idade}'),
            ),
            _criarDrawerItem(
              icon: Icons.account_balance_wallet,
              text: 'Saldo: ${widget.usuario.saldo}',
              onTap: () {},
            ),
            _criarDrawerItem(
              icon: Icons.money_off,
              text: 'Depositar Dinheiro',
              onTap: () => _depositarDinheiro(context, widget.usuario),
            ),
            _criarDrawerItem(
              icon: Icons.card_travel,
              text: 'Viagens Reservadas',
              onTap: () {
                //Navegar para a página que mostra as viagens reservadas
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViagensReservadasPage(
                        usuario: widget.usuario,
                        viagensReservadas: viagensReservadas,
                        updateSaldoCallback: atualizarSaldo),
                  ),
                );
              },
            ),
            _criarDrawerItem(
              icon: Icons.add_location,
              text: 'Cadastrar Destino',
              onTap: () {
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
            _criarDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Sair',
              onTap: _sairDoPerfil,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: destinos.length,
        itemBuilder: (context, index) {
          return Card(
            // Usa Card para cada destino
            child: ListTile(
              title: Text('${destinos[index].nome}'),
              subtitle: Text('Preço: ${destinos[index].preco}'),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(destinos[index].url),
              ),
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
            ),
          );
        },
      ),
    );
  }

  Widget _criarDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

FlatButton({required Text child, required Null Function() onPressed}) {}
