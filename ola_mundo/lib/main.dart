import 'package:flutter/material.dart';
import 'package:main/screens/TelaCadastro.dart';
import 'model/Destino.dart';
import 'model/Usuario.dart';
import 'telas/cadastrarDestino.dart';
import 'telas/showDestino.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaLogin(),
      routes: {
        '/screens/TelaCadastro.dart': (context) => TelaCadastro()
      },
    );
  }
}

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  //Map<Usuario, String> mapUsuários;

  void _entrar() {
    if (_loginController.text == 'adm' && _senhaController.text == '1234') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              TelaPrincipal(Usuario('Administrador', 30, 1000))
          )
      );
    } else {
      //
    }
  }

  void _cadastrarUsuario(){
      Navigator.of(context).pushNamed('/screens/TelaCadastro.dart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _entrar,
                  child: Text('Entrar'),
                ),
                Spacer(),
                ElevatedButton(onPressed: _cadastrarUsuario, child: Text('Cadastrar-se'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  TelaPrincipal(this.usuario);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  List<String> _viagensReservadas = [];
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
        _viagensReservadas.add(viagem.nome);
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Viagens Reservadas'),
                      content: ListView.builder(
                        itemCount: _viagensReservadas.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_viagensReservadas[index]),
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
                );
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
            title: Text('${destinos[index].nome} - ${destinos.length}'),
            subtitle: Text('Preço: ${destinos[index].preco}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDestino(destino: destinos[index]),
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
