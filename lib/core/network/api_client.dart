import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static const String _baseUrl = 'https://api.avellaneda-a-un-toque.com/v1';
  // TODO: Por seguridad, maneja la clave de API usando variables de entorno.
  // Se recomienda usar el paquete flutter_dotenv para cargar la clave desde un archivo .env
  static const String _apiKey = String.fromEnvironment('API_KEY', defaultValue: 'your-api-key-here');
  
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
    ));
    
    // Interceptor para logging en desarrollo
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
    
    // Interceptor para manejo de errores
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        debugPrint('API Error:  [31m [1m [4m${error.message} [0m');
        handler.next(error);
      },
    ));
  }
  
  // GET request genérico
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // POST request genérico
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // PUT request genérico
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // DELETE request genérico
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // Manejo de errores de Dio
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Tiempo de conexión agotado');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Error del servidor';
        return ApiException(message, statusCode);
      case DioExceptionType.cancel:
        return NetworkException('Solicitud cancelada');
      case DioExceptionType.connectionError:
        return NetworkException('Error de conexión');
      case DioExceptionType.badCertificate:
        return NetworkException('Error de certificado SSL');
      case DioExceptionType.unknown:
      default:
        return NetworkException('Error desconocido: ${error.message}');
    }
  }
}

// Excepciones personalizadas
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, this.statusCode);
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
} 