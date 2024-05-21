import 'package:dio/dio.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/screens/utils/dio_client.dart';

class UserServices {
  Future<User?> getUser() async {
    Dio dio = DioClient().dio;

    try {
      final response = await dio.get(
        userEndpoint,
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else if (response.statusCode == 401) {
        // Handle token expiration or invalid token
        print("Invalid or expired token");
        return null;
      }
      throw Exception("Failed to get user");
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }
}
