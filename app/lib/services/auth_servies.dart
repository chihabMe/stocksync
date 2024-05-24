import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/screens/utils/dio_client.dart';

class AuthServices {
  Dio dio = Dio();
  final storage = FlutterSecureStorage();
  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        loginEndpoint,
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        final access = response.data["access"];
        final refresh = response.data['refresh'];
        await storage.write(key: "access", value: access);
        await storage.write(key: "refresh", value: refresh);
        return true;
      }
      return false;
    } catch (error) {
      print("================");
      print("Error occurred: $error");
      print("================");
      rethrow;
    }
  }

  Future<bool> signup(
      String email, String username, String password, String userType) async {
    print("0user type ----------------");
    print(userType);
    print("0----------------");
    try {
      final response = await dio.post(
        signupEndpoint,
        data: {
          "email": email,
          "password": password,
          "password2": password,
          "username": username,
          "user_type": userType, // Add user type to the data being sent
        },
      );
      return response.statusCode == 201;
    } catch (error) {
      if (error is DioError) {
        print("------------dio---------");
        print(error.error);
        print(error.response?.data);
        print("------------dio---------");
      }
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await dio.post(logoutEndpoint);
      await storage.delete(key: "access");
      await storage.delete(key: "refresh");
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await storage.read(key: "refresh");
      if (refreshToken == null) {
        return false;
      }

      final response = await dio.post(
        refreshEndpoint,
        data: {
          "refresh": refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final newAccess = response.data["access"];
        await storage.write(key: "access", value: newAccess);
        return true;
      }
      return false;
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await storage.read(key: "access");
    } catch (error) {
      print("Error occurred: $error");
      rethrow;
    }
  }
}
