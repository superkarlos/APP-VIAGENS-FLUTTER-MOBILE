import 'package:My_App/provider/destiny_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/provider/destiny.dart';

class DestinyDetailPage extends StatelessWidget {
  const DestinyDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final destiny = Provider.of<Destiny>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(destiny.title),
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
                child: Image.network(destiny.imageUrl),
              ),
            ),
            Container(
              color: Colors.red, 
              child: Text(
                '\$${destiny.price.toString()}',
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
              child: Text(destiny.description),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Consumer<Destiny>(
                    builder: (context, destiny, child) => Icon(
                        destiny.isFavorite ? Icons.favorite : Icons.favorite_border),
                  ),
                  onPressed: () {
                    destiny.toggleFavorite();
                    Provider.of<DestinyList>(context, listen: false).updateFavorites();
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
