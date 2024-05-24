import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/models/CartItem.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/utils/dio_client.dart';

class CartService {
  static const _cartKey = 'cart';
  Dio dio = DioClient().dio;

  VoidCallback? cartChangeListener; // Add a callback for cart changes

  Future<void> addToCart(Product product, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    List<CartItem> currentCart = cartItems.map((item) {
      Map<String, dynamic> itemMap = jsonDecode(item);
      return CartItem.fromJson(itemMap);
    }).toList();

    bool found = false;
    for (var cartItem in currentCart) {
      if (cartItem.product.id == product.id) {
        cartItem.quantity += quantity;
        found = true;
        break;
      }
    }

    if (!found) {
      currentCart.add(CartItem(product: product, quantity: quantity));
    }

    List<String> updatedCart =
        currentCart.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, updatedCart);
    if (cartChangeListener != null) {
      cartChangeListener!();
    }
  }

  Future<void> updateQuantity(Product product, int newQuantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    List<CartItem> currentCart = cartItems.map((item) {
      Map<String, dynamic> itemMap = jsonDecode(item);
      return CartItem.fromJson(itemMap);
    }).toList();

    if (newQuantity > 0) {
      for (var cartItem in currentCart) {
        if (cartItem.product.id == product.id) {
          cartItem.quantity = newQuantity;
          break;
        }
      }
    } else {
      currentCart.removeWhere((cartItem) => cartItem.product.id == product.id);
    }

    List<String> updatedCart =
        currentCart.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, updatedCart);
  }

  Future<void> removeFromCart(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    List<CartItem> currentCart = cartItems.map((item) {
      Map<String, dynamic> itemMap = jsonDecode(item);
      return CartItem.fromJson(itemMap);
    }).toList();

    currentCart.removeWhere((item) => item.product.id == product.id);

    List<String> updatedCart =
        currentCart.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, updatedCart);
  }

  Future<List<CartItem>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];
    return cartItems.map((item) {
      Map<String, dynamic> itemMap = jsonDecode(item);
      return CartItem.fromJson(itemMap);
    }).toList();
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  Future<Map<String, dynamic>> applyCoupon(String couponCode) async {
    try {
      final response = await dio.post(
        couponEndpoint,
        data: {'coupon_code': couponCode},
      );
      if (response.statusCode == 200) {
        // Coupon applied successfully, return the discount percentage
        return {
          'success': true,
          'discount_percentage': response.data['discount_percentage']
        };
      } else {
        return {
          'success': false,
          'discount_percentage': 0
        }; // Invalid coupon code or other error
      }
    } catch (error) {
      print("===================");
      if (error is DioError && error.response != null) {
        print("Error occurred: ${error.message}");
        print("Response data: ${error.response!.data}");
        print("===================");
      }
      throw Exception('Failed to apply coupon: $error');
    }
  }
}
