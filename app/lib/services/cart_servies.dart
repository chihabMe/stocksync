import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/CartItem.dart';
import 'package:shop_app/models/Product.dart';

class CartService {
  static const _cartKey = 'cart';

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
}
