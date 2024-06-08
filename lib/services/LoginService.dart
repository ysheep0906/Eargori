import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> login(String username, String password) async {
    await dotenv.load(fileName: '.env');
    String baseUrl = dotenv.env['API_URL'].toString();
    try {
      final response = await _dio.post(
        '$baseUrl/users/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 404) {
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to login');
    }
  }
}
