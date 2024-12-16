import 'dart:convert';

import 'package:flareline/core/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = '${Constant.baseUrl}/auth';

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<Map<String, String>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        await _saveTokens(responseBody['token'], responseBody['refreshToken']);
        return {
          'accessToken': responseBody['token'],
          'refreshToken': responseBody['refreshToken'],
        };
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        throw Exception(responseBody['message']);
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<void> signUp(
      String name, String email, String phone, String password) async {
    try {
      print('$baseUrl/sign-up');
      final response = await http.post(
        Uri.parse('$baseUrl/sign-up'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      print(response);

      if (response.statusCode != 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        throw Exception(responseBody['message']);
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
