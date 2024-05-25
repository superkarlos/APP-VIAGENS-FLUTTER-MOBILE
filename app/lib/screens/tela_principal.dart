import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:My_App/model/Usuario.dart';
import 'package:My_App/model/Destino.dart';
import 'package:My_App/model/Avaliacao.dart';
import 'package:My_App/model/Foto.dart';
import 'package:My_App/screens/tela_de_login.dart';
import 'package:My_App/screens/tela_deposito.dart';
import 'package:My_App/screens/tela_viagens_reservadas.dart';
import 'package:My_App/screens/tela_de_cadastro_destinos.dart';
import 'package:My_App/screens/show_destino.dart';
import 'package:My_App/screens/lista_comentarios.dart';
import 'package:My_App/screens/lista_fotos.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  const TelaPrincipal(this.usuario, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<Destino> viagensReservadas = [];
  List<Destino> destinos = [];
  List<Avaliacao> avaliacoes = [];
  List<Foto> fotos = [];

  @override
  void initState() {
    super.initState();
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
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
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
        title: const Text('Comprar Viagem'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _sairDoApp,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors
                    .lightBlueAccent, // Cor de fundo para o cabeçalho do Drawer
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
              icon: Icons.comment,
              text: 'Fazer avaliação',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvaliacaoPage(
                        avaliacoes: avaliacoes, destinosDisponiveis: destinos),
                  ),
                ).then((novaAvaliacao) {
                  if (novaAvaliacao != null) {
                    setState(() {
                      // destinos.add(novoDestino);
                    });
                  }
                });
              },
            ),
            _criarDrawerItem(
              icon: Icons.image,
              text: 'Upload de fotos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FotoPage(fotos: fotos),
                  ),
                ).then((novaFoto) {
                  if (novaFoto != null) {
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
                      avaliacoes: avaliacoes,
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

  Widget _criarDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

FlatButton({required Text child, required Null Function() onPressed}) {}
