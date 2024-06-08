import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;

class RegiSentenceService {
  final Dio _dio = Dio();
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> getPlace() async {
    await dotenv.load(fileName: '.env');
    String baseUrl = dotenv.env['API_URL'].toString();
    String? token = await storage.read(key: 'jwt_token');

    try {
      final response = await _dio.get(
        '$baseUrl/places',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get place0');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 403) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 404) {
        throw Exception(e.response?.data['message']);
      } else {
        throw Exception('Failed to get place1');
      }
    } catch (e) {
      throw Exception('Failed to get place2');
    }
  }

  Future<Map<String, dynamic>?> createSentence(
      String sentence, String place) async {
    await dotenv.load(fileName: '.env');
    String baseUrl = dotenv.env['API_URL'].toString();
    String? token = await storage.read(key: 'jwt_token');

    try {
      final response = await _dio.post(
        '$baseUrl/sentences/create',
        data: {
          'sentence': sentence,
          'place': place,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to create sentence');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message']);
      } else if (e.response?.statusCode == 403) {
        throw Exception(e.response?.data['message']);
      } else {
        print(e.response?.data);
        throw Exception('Failed to create sentence');
      }
    } catch (e) {
      throw Exception('Failed to create sentence');
    }
  }
}
