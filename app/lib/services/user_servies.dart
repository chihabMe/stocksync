import 'package:dio/dio.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/screens/utils/dio_client.dart';

class UserServices {
  Future<User> getUser() async {
    Dio dio = DioClient().dio;

    try {
      final response = await dio.get(
        userEndpoint,
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      throw Exception("Failed to get user");
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }
}
