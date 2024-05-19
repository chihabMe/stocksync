import 'package:flutter/material.dart';

class ProductImage {
  final String id;
  final String image;

  ProductImage({
    required this.id,
    required this.image,
  });

  // Method to convert a ProductImage to JSON
  factory ProductImage.fromJson(Map<String, dynamic> json) {
    try {
      return ProductImage(
        id: json['id'],
        image: json['image'],
      );
    } catch (e) {
      print("   parsing ProductImage JSON: $e");
      rethrow;
    }
  }
}
