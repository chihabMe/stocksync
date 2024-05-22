import 'package:flutter/material.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/models/Product.dart';

class Order {
  final String id;
  final User user;
  final String firstName;
  final String lastName;
  final String address;
  final String phone;
  final String city;
  final String status;
  final String state;
  final List<OrderItem> items;
  final double total;
  final DateTime date; // Added date field

  Order({
    required this.id,
    required this.total,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.city,
    required this.status,
    required this.state,
    required this.items,
    required this.date, // Added date field
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      List<OrderItem> items = (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList();
      double total = items.fold(
          0.0, (sum, item) => sum + item.product.price * item.quantity);

      return Order(
        id: json["id"],
        user: User.fromJson(json['user']),
        firstName: json['first_name'],
        lastName: json['last_name'],
        address: json['address'],
        phone: json['phone'],
        city: json['city'],
        status: json['status'],
        state: json['state'],
        items: items,
        total: total,
        date: DateTime.parse(json['date']), // Parse date from JSON string
      );
    } catch (error) {
      print("-------------------");
      print("error during parsing order data $error");
      print("-------------------");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'phone': phone,
      'city': city,
      'status': status,
      'state': state,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'date': date.toIso8601String(), // Convert date to ISO 8601 string
    };
  }
}

class OrderItem {
  final int quantity;
  final Product product;

  OrderItem({
    required this.quantity,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    try {
      return OrderItem(
        quantity: json['quantity'],
        product: Product.fromJson(json['product']),
      );
    } catch (error) {
      print("-------------------");
      print("error during parsing order data $error");
      print("-------------------");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'quantity': quantity,
        'product': product.toJson(),
      };
    } catch (error) {
      print("-------------------");
      print("error during parsing order data $error");
      print("-------------------");
      rethrow;
    }
  }
}
