import 'package:dio/dio.dart';
import 'package:weather/secrets.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<Response<Map<String, dynamic>>> getForecast({
    required String location,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/forecast',
        queryParameters: {'q': location, 'APPID': Secrets.apiKey},
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          error:
              'API Error: ${e.response?.statusCode} ${e.response?.statusMessage}',
          type: e.type,
        );
      } else {
        throw DioException(
          requestOptions: e.requestOptions,
          error: 'Network Error: ${e.message}',
          type: DioExceptionType.connectionError,
        );
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
