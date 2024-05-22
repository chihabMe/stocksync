import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/screens/utils/dio_client.dart';

class OrderService {
  Dio dio = DioClient().dio;
  final String _orderApiUrl =
      "https://yourapi.com/orders"; // Replace with your API endpoint

  Future<bool> submitOrder(Map<String, dynamic> orderData) async {
    final response = await dio.post(orderEndpoint, data: orderData);

    if (response.statusCode == 201) {
      return true;
    } else {
      // Handle error
      throw Exception("Failed to submit order");
    }
  }
}
