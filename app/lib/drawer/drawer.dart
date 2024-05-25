import 'package:My_App/screens/tela_deposito.dart';
import 'package:My_App/screens/tela_viagens_reservadas.dart';
import 'package:flutter/material.dart';
import 'package:My_App/model/Usuario.dart';
import 'package:My_App/pages/viagens_reservadas_page.dart';
import 'package:My_App/model/destino.dart';
import 'package:My_App/model/avaliacao.dart';
import 'package:My_App/model/foto.dart';

class CustomDrawer extends StatelessWidget {
  final Usuario usuario;
  final List<Viagem> viagensReservadas;
  final List<Destino> destinos;
  final List<Avaliacao> avaliacoes;
  final List<Foto> fotos;
  final Function updateSaldoCallback;
  final Function sairDoPerfil;

  const CustomDrawer({
    required this.usuario,
    required this.viagensReservadas,
    required this.destinos,
    required this.avaliacoes,
    required this.fotos,
    required this.updateSaldoCallback,
    required this.sairDoPerfil,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            accountName: Text(usuario.nome),
            accountEmail: Text('Idade: ${usuario.idade}'),
          ),
          _criarDrawerItem(
            icon: Icons.account_balance_wallet,
            text: 'Saldo: ${usuario.saldo}',
            onTap: () {},
          ),
          _criarDrawerItem(
            icon: Icons.money_off,
            text: 'Depositar Dinheiro',
            onTap: () => _depositarDinheiro(context, usuario),
          ),
          _criarDrawerItem(
            icon: Icons.card_travel,
            text: 'Viagens Reservadas',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViagensReservadasPage(
                    usuario: usuario,
                    viagensReservadas: viagensReservadas,
                    updateSaldoCallback: updateSaldoCallback,
                  ),
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
                    avaliacoes: avaliacoes,
                    destinosDisponiveis: destinos,
                  ),
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
            onTap: () => sairDoPerfil(),
          ),
        ],
      ),
    );
  }

  ListTile _criarDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
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
}
