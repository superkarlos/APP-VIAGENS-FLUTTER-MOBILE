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
    _adicionarDestinosPadrao();
  }

  void _adicionarDestinosPadrao() {
    // Adiciona destinos padrão à lista
    // Substitua os links por imagens válidas de cada destino
    destinos.add(Destino(
      'Paris',
      5000,
      'https://www.segueviagem.com.br/wp-content/uploads/2016/08/Paris-Franca-shutterstock_1829492048-1000x675.jpg',
      'Paris, a Cidade Luz, é um ícone de cultura, história e romance. Com suas elegantes avenidas, monumentos icônicos como a Torre Eiffel e o Louvre, e a rica cena gastronômica e artística, Paris é um destino imperdível para quem busca experiências sofisticadas e charmosas na Europa.'
    ));
    destinos.add(Destino(
      'Tokyo',
      3000,
      'https://imgmd.net/images/v1/guia/1684253/tokyo-japao-199-c.jpg',
      'Tokyo, a capital do Japão, é uma cidade dinâmica onde o tradicional se mistura harmoniosamente com o moderno. Conhecida por suas luzes neon, arquitetura futurista, culinária diversificada e tecnologia de ponta, Tóquio oferece uma experiência única que combina história e inovação em cada esquina. Dos templos antigos aos arranha-céus impressionantes, Tóquio cativa seus visitantes com sua cultura vibrante, vida noturna animada e uma atmosfera que nunca para de surpreender.'
    ));
    destinos.add(Destino(
      'Xangai',
      3500,
      'https://viajologoexisto.com.br/wp-content/uploads/2018/01/O62A9823.jpg',
      'Xangai é uma metrópole cosmopolita situada na China, conhecida por sua arquitetura moderna e vibrante vida urbana. Com uma mistura fascinante de culturas orientais e ocidentais, Xangai oferece uma experiência única aos visitantes. Dos arranha-céus imponentes ao charme dos bairros históricos, como o Bund, esta cidade encanta com suas opções gastronômicas, compras de alto nível e uma vida noturna agitada. Descubra a essência de uma metrópole em constante evolução em Xangai.'
    ));
    destinos.add(Destino(
      'Rio De Janeiro',
      1500,
      'https://a.cdn-hotels.com/gdcs/production165/d100/5e0a7326-4dd3-40cc-9eb7-3af978f69b3d.jpg?impolicy=fcrop&w=800&h=533&q=medium',
      'O Rio de Janeiro é um dos destinos mais icônicos do Brasil, famoso por suas belas praias, paisagens naturais deslumbrantes e atmosfera animada. Conhecida como a "Cidade Maravilhosa", oferece uma combinação única de praias ensolaradas, como Copacabana e Ipanema, com montanhas majestosas, como o Pão de Açúcar e o Cristo Redentor. Além disso, o Rio é rico em cultura, com festivais de música, dança e arte ao longo do ano. Explore a energia contagiante e a diversidade cultural do Rio de Janeiro.'
    ));
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TelaLogin()));
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
              icon: Icons.comment,
              text: 'Fazer avaliação',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvaliacaoPage(avaliacoes: avaliacoes, destinosDisponiveis: destinos),
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

  Widget _criarDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

FlatButton({required Text child, required Null Function() onPressed}) {}
