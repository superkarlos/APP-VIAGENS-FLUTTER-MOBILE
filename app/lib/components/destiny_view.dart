import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:My_App/model/destiny.dart';
import 'package:My_App/utils/routes.dart';

class DestinyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final destiny = Provider.of<Destiny>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            destiny.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.DESTINY_DETAIL, arguments: destiny);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            destiny.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
