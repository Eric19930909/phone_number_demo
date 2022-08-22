import 'package:app/network/network_config.dart';
import 'package:dio/dio.dart';

class DioManager {
  factory DioManager() {
    return _instance;
  }

  DioManager._internal() {
    final options = BaseOptions(
      baseUrl: NetworkConfig.baseUrl,
      connectTimeout: NetworkConfig.connectTimeout,
      receiveTimeout: NetworkConfig.receiveTimeout,
      sendTimeout: NetworkConfig.sendTimeout,
    );
    _dio = Dio(options);
  }

  static final DioManager _instance = DioManager._internal();
  late Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
