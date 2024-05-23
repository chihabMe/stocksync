import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/models/Coupon.dart';

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

  Future<bool> toggleLike(String productId) async {
    try {
      final response = await dio.post("$productEndpoint$productId/like/");
      return response.statusCode == 200;
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<List<Product>> getLikedProducts() async {
    try {
      final response = await dio.get(likedProductsEndpoint);
      ListResponse<Product> listResponse =
          ListResponse.fromJson(response.data, Product.fromJson);
      List<Product> products = listResponse.results;
      return products;
    } catch (error) {
      print("Error accursed : $error ");
      rethrow; // Re-throws the caught error for higher-level handling
    }
  }

  Future<Product> getProduct(String productId) async {
    try {
      final response = await dio.get("$productEndpoint$productId/");
      Product product = Product.fromJson(response.data);
      return product;
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await dio.get("$productEndpoint?query=$query");
      ListResponse<Product> listResponse =
          ListResponse.fromJson(response.data, Product.fromJson);
      List<Product> products = listResponse.results;
      return products;
    } catch (error) {
      print("Error accursed : $error ");
      rethrow; // Re-throws the caught error for higher-level handling
    }
  }

  Future<List<Product>> getSellerProducts() async {
    try {
      final response = await dio.get(sellerProductsEndpoint);
      ListResponse<Product> listResponse =
          ListResponse.fromJson(response.data, Product.fromJson);
      List<Product> products = listResponse.results;
      return products;
    } catch (error) {
      print("Error accursed : $error ");
      rethrow; // Re-throws the caught error for higher-level handling
    }
  }

  Future<bool> addProduct(NewProduct product, List<XFile> images) async {
    try {
      FormData formData = FormData.fromMap({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "stock": product.stock,
        "category": product.category,
        "images": await Future.wait(images.map((image) async {
          return await MultipartFile.fromFile(image.path, filename: image.name);
        }))
      });

      final response = await dio.post(sellerProductsEndpoint, data: formData);

      // Check if response is successful
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Print detailed error information including the response body
      if (error is DioError && error.response != null) {
        print("Error occurred: ${error.message}");
        print("Response data: ${error.response!.data}");
      } else {
        print("Error occurred: $error");
      }

      // Rethrow the error to propagate it upwards
      rethrow;
    }
  }

  Future<List<Coupon>> getSellerCoupons() async {
    try {
      final response = await dio.get(sellerCouponsEndpoint);
      ListResponse<Coupon> listResponse =
          ListResponse.fromJson(response.data, Coupon.fromJson);
      List<Coupon> coupons = listResponse.results;
      return coupons;
    } catch (error) {
      if (error is DioError) {
        if (error.response != null) {
          // Access response data
          var responseData = error.response?.data;
          print("================");
          print("Error occurred: ${error.message}");
          print("Response data: $responseData");
          print("================");
        } else {
          print("DioError without response");
        }
      } else {
        print("Error occurred: $error");
      }
      rethrow;
    }
  }

  Future<Coupon> generateSellerCoupon(int discount, String productId) async {
    try {
      final response = await dio.post(
        sellerCouponsEndpoint,
        data: {
          "discount": discount.toString(),
          "product_id": productId,
        },
      );

      if (response.statusCode == 201) {
        Coupon coupon = Coupon.fromJson(response.data);
        return coupon;
      } else {
        throw "Failed to generate coupon. Status code: ${response.statusCode}";
      }
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<bool> deleteSellerCoupon(String couponId) async {
    try {
      final response = await dio.delete('$sellerCouponsEndpoint$couponId/');

      return response.statusCode == 204;
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await dio.delete('$productEndpoint$productId/seller/');

      return response.statusCode == 204;
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<bool> updateProduct(
      String productId, NewProduct product, List<XFile> images) async {
    try {
      FormData formData = FormData.fromMap({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "stock": product.stock,
        "category": product.category,
        "images": await Future.wait(images.map((image) async {
          return await MultipartFile.fromFile(image.path, filename: image.name);
        }))
      });

      final response =
          await dio.put('$productEndpoint$productId/seller/', data: formData);

      // Check if response is successful
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Print detailed error information including the response body
      print("===================");
      if (error is DioError && error.response != null) {
        print("Error occurred: ${error.message}");
        print("Response data: ${error.response!.data}");
        print("===================");
      } else {
        print("Error occurred: $error");
      }

      // Rethrow the error to propagate it upwards
      rethrow;
    }
  }
}
