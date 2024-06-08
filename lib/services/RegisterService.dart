import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> register(
      String username, String password, String nickname) async {
    await dotenv.load(fileName: '.env');
    String baseUrl = dotenv.env['API_URL'].toString();
    try {
      final response = await _dio.post(
        '$baseUrl/users/register',
        data: {
          'username': username,
          'password': password,
          'nickname': nickname,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 409) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
