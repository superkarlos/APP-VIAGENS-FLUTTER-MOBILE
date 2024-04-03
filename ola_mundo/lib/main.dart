import 'package:flutter/material.dart';

import 'model/Ususario.dart';

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

  void _entrar() {
    if (_loginController.text == 'adm' && _senhaController.text == '1234') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              TelaPrincipal(Usuario('Administrador', 30, 1000))));
    } else {
      // Mostrar mensagem de erro de login
      // aqui voces colocam para mostrar msg de erro
    }
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
            ElevatedButton(
              onPressed: _entrar,
              child: Text('Entrar'),
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
  List<Map<String, dynamic>> _viagens = [
    {'destino': 'Paris', 'preço': 2000},
    {'destino': 'Tokyo', 'preço': 3000},
    {'destino': 'Japão', 'preço': 5000},
    {'destino': 'Brasil', 'preço': 3000},
    // Adicione mais viagens aqui
  ];

  void _reservarViagem(Map<String, dynamic> viagem) {
    int precoViagem = viagem['preço'];
    if (widget.usuario.saldo >= precoViagem) {
      setState(() {
        widget.usuario.saldo -= precoViagem;
        _viagensReservadas.add(viagem['destino']);
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
              title: Text('Sair'),
              onTap: _sairDoPerfil,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _viagens.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_viagens[index]['destino']),
            subtitle: Text('Preço: ${_viagens[index]['preço']}'),
            onTap: () {
              _reservarViagem(_viagens[index]);
            },
          );
        },
      ),
    );
  }
}

FlatButton({required Text child, required Null Function() onPressed}) {}
