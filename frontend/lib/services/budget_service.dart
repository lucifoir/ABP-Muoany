import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/token_storage.dart';
import 'package:frontend/services/auth_service.dart'; // tambahkan ini

class BudgetService {
  static const String baseUrl =
      'http://192.168.0.100:5000/api/budgets'; // emulator

  static Future<List<Map<String, dynamic>>> fetchBudgets() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['budgets']);
    } else {
      throw Exception('Failed to load budgets: ${response.statusCode}');
    }
  }

  static Future<bool> upsertBudget({
    required String categoryName,
    required double limitAmount,
  }) async {
    final token = await AuthService.getToken();

    print('📦 Bearer Token: $token');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'category_name': categoryName,
        'limit_amount': limitAmount,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<bool> deleteBudget(String categoryName) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'category_name': categoryName}),
    );

    return response.statusCode == 200;
  }
}
