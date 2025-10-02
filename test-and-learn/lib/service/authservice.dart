import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:8085";

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      String token = data['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'].toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('userRole', role);

      return true;
    } else {
      print('Failed to log in: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  Future<bool> registerJobSeeker({
    required Map<String, dynamic> user,
    required Map<String, dynamic> jobSeeker,
    required File photo,
  }) async {
    final dio = Dio();

    final formData = FormData();
    formData.fields.add(MapEntry('user', jsonEncode(user)));
    formData.fields.add(MapEntry('jobSeeker', jsonEncode(jobSeeker)));

    final mimeType = lookupMimeType(photo.path) ?? 'image/jpeg';
    final split = mimeType.split('/');
    final mediaType =
    MediaType(split[0], split.length > 1 ? split[1] : 'jpeg');

    formData.files.add(
      MapEntry(
        'imageFile',
        await MultipartFile.fromFile(
          photo.path,
          filename: basename(photo.path),
          contentType: mediaType,
        ),
      ),
    );

    try {
      final response = await dio.post(
        '$baseUrl/api/jobseeker/',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful: ${response.data}');
        return true;
      } else {
        print('Registration failed: ${response.statusCode} ${response.data}');
        return false;
      }
    } on DioError catch (e) {
      print('Dio error: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }

  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
}
