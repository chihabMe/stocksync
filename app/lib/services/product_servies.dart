import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shop_app/endpoints.dart';

import 'package:shop_app/models/Product.dart';
import 'package:shop_app/models/ListResponse.dart';
import 'package:shop_app/screens/utils/dio_client.dart'; // Import the ListResponse model

class ProductService {
  final Dio dio = DioClient().dio;

  Future<List<Product>> getNewProducts() async {
    try {
      final response = await dio.get("$productEndpoint?order_by=new");
      ListResponse<Product> listResponse =
          ListResponse.fromJson(response.data, Product.fromJson);
      List<Product> products = listResponse.results;
      return products;
    } catch (error) {
      print("Error accursed : $error ");
      rethrow; // Re-throws the caught error for higher-level handling
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get(productEndpoint);

      if (response.statusCode == 200) {
        ListResponse<Product> listResponse =
            ListResponse<Product>.fromJson(response.data, Product.fromJson);

        // Extract the products from the ListResponse
        List<Product> products = listResponse.results;

        return products;
      } else {
        throw "Can't get products. Status code: ${response.statusCode}";
      }
    } catch (error) {
      print("Error occurred: $error");
      rethrow; // Re-throws the caught error for higher-level handling
    }
  }
}
