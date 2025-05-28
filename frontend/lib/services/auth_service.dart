import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      'http://192.168.0.100:5000/api/auth'; // GANTI KE IP MASING MASING (IPCONFIG)

  // Login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      await prefs.setString('name', data['user']['name']);
      await prefs.setString('email', data['user']['email']);

      return true;
    } else {
      return false;
    }
  }

  // Register
  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    print('📤 Sending registration data:');
    print('Name: $name');
    print('Email: $email');
    print('Password: $password');
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    print('📥 Backend response: ${response.statusCode}');
    print('🔽 Body: ${response.body}');

    return response.statusCode == 201;
  }

  // Logout (hapus token)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Ambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
