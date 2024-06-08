import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;

class HomeService {
  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getFavorites() async {
    await dotenv.load(fileName: '.env');
    String baseUrl = dotenv.env['API_URL'].toString();
    String? token = await storage.read(key: 'jwt_token');
    try {
      final response = await _dio.get(
        '$baseUrl/sentences/favorite',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('status');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 404) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 403) {
        //JWT
        print(token);
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception('error');
      }
    } catch (e) {
      throw Exception('error');
    }
  }
}
