import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destiny_list.dart';
import 'package:My_App/model/destiny.dart';

import 'package:My_App/components/destiny_view.dart';

class DestinyGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DestinyList>(context);

    final List<Destiny> loadedDestinations = provider.items;

    return ValueListenableBuilder(
      valueListenable: provider.updateNotifier,
      builder: (ctx, value, _) {
        final List<Destiny> loadedDestinations = provider.items;
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedDestinations.length,
          //# ProductItem vai receber a partir do Provider
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            //create: (ctx) => Product(),
            value: loadedDestinations[i],
            //child: ProductItem(product: loadedDestinations[i]),
            child: DestinyView(),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, //2 produtos por linha
            childAspectRatio: 2 / 1, //diemnsao de cada elemento
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        );
      },
    );
  }
}
