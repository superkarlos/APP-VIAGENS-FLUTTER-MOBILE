import 'package:flutter/material.dart';
import 'package:My_App/model/destino.dart';

class BaseDestinyView extends StatelessWidget {
  final Destino destiny;
  final Widget? trailing;
  final VoidCallback? onTap;

  const BaseDestinyView({
    Key? key,
    required this.destiny,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            destiny.imagemUrl,
            fit: BoxFit.cover,
          ),
          onTap: onTap,
        ),
        footer: GridTileBar(
          backgroundColor: Color.fromARGB(221, 58, 7, 82),
          title: Text(
            destiny.nome,
            textAlign: TextAlign.center,
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
