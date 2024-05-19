import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/endpoints.dart';
import 'package:shop_app/services/auth_servies.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final AuthServices _authServices = AuthServices();

  DioClient._internal(this._dio);

  static final DioClient _instance = DioClient._internal(Dio());

  factory DioClient() {
    _instance._dio.interceptors.clear();
    _instance._dio.interceptors.add(_instance._createInterceptor());
    return _instance;
  }

  Interceptor _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _storage.read(key: "access");
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
        handler.next(options);
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshTokenSuccess = await _authServices.refreshToken();
          if (refreshTokenSuccess) {
            final newAccessToken = await _storage.read(key: "access");
            if (newAccessToken != null) {
              error.requestOptions.headers["Authorization"] =
                  "Bearer $newAccessToken";
              final retryRequest = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(retryRequest);
            }
          }
        }
        handler.next(error);
      },
    );
  }

  Dio get dio => _dio;
}
