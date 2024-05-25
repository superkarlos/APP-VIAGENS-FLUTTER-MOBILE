import 'package:flutter/material.dart';

class Destiny with ChangeNotifier {
  //final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Destiny({
    //required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  factory Destiny.fromJson(Map<String, dynamic> json) {
    return Destiny(
      //id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite']
    );
  }

}
