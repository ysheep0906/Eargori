import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;

class CreatePlaceService {
  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<void> createPlace(String place) async {
    await dotenv.load(fileName: '.env');
    String baseUrl = dotenv.env['API_URL'].toString();
    String? token = await storage.read(key: 'jwt_token');
    try {
      final response = await _dio.post(
        '$baseUrl/places/create',
        data: {
          'place': place,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Place: $response');
      } else {
        throw Exception('Failed to create place');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 403) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception('Failed to create place');
      }
    } catch (e) {
      throw Exception('Failed to create place');
    }
  }
}
