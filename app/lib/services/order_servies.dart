import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shop_app/models/ListResponse.dart';
import 'package:shop_app/models/Order.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/utils/dio_client.dart';
import 'package:shop_app/endpoints.dart';

class OrderServices {
  Dio dio = DioClient().dio;

  Future<bool> submitOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await dio.post(orderEndpoint, data: orderData);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Order>> getOrdersList() async {
    final response = await dio.get(orderEndpoint);

    if (response.statusCode == 200) {
      ListResponse<Order> listResponse =
          ListResponse.fromJson(response.data, Order.fromJson);
      List<Order> orders = listResponse.results;
      return orders;
    } else {
      // Handle error
      throw Exception("Failed to fetch orders");
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await dio.put('$orderEndpoint$orderId/cancel/');
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("error in cancel order $error");
      rethrow;
    }
  }

  Future<bool> createProductComplaint(String productId) async {
    try {
      final response = await dio.post(complainEndpoint, data: {
        'productId': productId,
      });
      if (response.statusCode == 200) {
        return true; // Return true if complaint is created successfully
      } else {
        // Handle non-200 status codes
        print('Error creating product complaint: ${response.statusCode}');
        return false; // Return false if an error occurs
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error creating product complaint: $error');
      return false; // Return false if an error occurs
    }
  }

  Future<List<Order>> getSellerOrders() async {
    try {
      String finalEndpoint = orderEndpoint + "seller/";
      final response = await dio.get(finalEndpoint);

      if (response.statusCode == 200) {
        ListResponse<Order> listResponse =
            ListResponse.fromJson(response.data, Order.fromJson);
        List<Order> orders = listResponse.results;
        return orders;
      } else {
        // Handle error
        throw Exception("Failed to fetch seller orders");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await dio
          .put('$orderEndpoint$orderId/seller/', data: {'status': status});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("===================");
      print("error in updating order status $error");
      print("===================");
      rethrow;
    }
  }

  // Add this new method to accept an order
  Future<bool> acceptOrder(String orderId) async {
    return await updateOrderStatus(orderId, 'accepted');
  }
}
