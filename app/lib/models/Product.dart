import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String? description;
  final List<String> images; // Change type to ProductImage
  final double rating, price;
  final bool isLiked;
  final int stock;

  Product({
    required this.id,
    required this.stock,
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
      List<dynamic> images = json['images'] ?? json["image_urls"];
      List<String> imageUrls = images.map((image) => image.toString()).toList();

      return Product(
        id: json['id'],
        name: json['name'],
        stock: json['stock'],
        description: json['description'],
        images: imageUrls, // Assign the list of strings to the images field
        rating: json['rating'].toDouble(),
        price: double.parse(json['price'].toString()),
        isLiked: json['is_liked'] ?? false,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'stock': stock,
      'rating': rating,
      'price': price,
      'is_liked': isLiked,
    };
  }
}

class NewProduct {
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images; // List of image URLs or paths
  final String category; // New field for category

  NewProduct({
    required this.name,
    required this.price,
    required this.stock,
    required this.images,
    required this.category,
    required this.description,
  });

  factory NewProduct.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing JSON data for NewProduct: $json");
      // Convert the list of dynamic to a list of strings
      List<dynamic> images = json['images'] ?? json["image_urls"];
      List<String> imageUrls = images.map((image) => image.toString()).toList();

      return NewProduct(
        name: json['name'],
        price: double.parse(json['price'].toString()),
        stock: json['stock'],
        images: imageUrls,
        category: json['category'],
        description: json['description'],
      );
    } catch (e) {
      print("Error parsing NewProduct JSON: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'images': images,
      'category': category,
      'description': description,
    };
  }
}
