import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String? description;
  final List<String> images; // Change type to ProductImage
  final double rating, price;
  final bool isLiked;

  Product({
    required this.id,
    required this.images,
    this.rating = 0.0,
    this.isLiked = false,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing JSON data for Product: $json");
      // Convert the list of dynamic to a list of strings
      List<dynamic> images = json['images'];
      List<String> imageUrls = images.map((image) => image.toString()).toList();

      return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        images: imageUrls, // Assign the list of strings to the images field
        rating: json['rating'].toDouble(),
        price: double.parse(json['price'].toString()),
        isLiked: json['is_liked'],
      );
    } catch (e) {
      print("Product model parsing Product JSON: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'rating': rating,
      'price': price,
      'is_liked': isLiked,
    };
  }
}

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

List<Product> demoProducts = [];
