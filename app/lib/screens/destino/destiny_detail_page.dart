import 'package:My_App/service/destino_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destino.dart';

class DestinyDetailPage extends StatelessWidget {
  const DestinyDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final destiny = Provider.of<Destino>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(destiny.nome),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 238, 107, 107)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(destiny.imagemUrl),
              ),
            ),
            Container(
              color: Colors.red, 
              child: Text(
                '\$${destiny.preco.toString()}',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 30, 
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(destiny.descricao),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Consumer<Destino>(
                    builder: (context, destiny, child) => Icon(
                        destiny.isFavorite ? Icons.favorite : Icons.favorite_border),
                  ),
                  onPressed: () {
                    destiny.toggleFavorite();
                    Provider.of<DestinoService>(context, listen: false).updateFavorites();
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
