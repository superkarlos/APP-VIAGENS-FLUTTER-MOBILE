import 'dart:convert';
import 'dart:math';

import 'package:My_App/data/data.dart';
import 'package:My_App/model/destiny.dart';
import 'package:flutter/material.dart';


class DestinyList with ChangeNotifier {

  List<Destiny> _items = dummyDestinos;
  ValueNotifier<int> updateNotifier = ValueNotifier(0);

  List<Destiny> get items {
    return [..._items];
  }

  void updateFavorites() {
    updateNotifier.value++;
    notifyListeners();
  }

  //bool _showFavoriteOnly = false;
  //ValueNotifier<int> updateNotifier = ValueNotifier(0);

  /*List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }*/

}
