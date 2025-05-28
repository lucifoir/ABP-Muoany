import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  static const String baseUrl = 'http://192.168.0.100:5000/api/records';

  /// Ambil semua transaksi milik user yang sedang login
  static Future<List<Transaction>> fetchTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token not found');

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['records'];
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      print('❌ Failed to fetch transactions: ${response.statusCode}');
      print('🔽 ${response.body}');
      throw Exception('Failed to fetch transactions');
    }
  }

  /// Tambah transaksi baru (akan dikategorikan otomatis di backend)
  static Future<Transaction?> addTransaction({
    required String title,
    required String type, // 'income' atau 'expense'
    required double amount,
    required String description,
    required DateTime transactionDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token not found');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'type': type,
        'amount': amount,
        'description': description,
        'transaction_date': transactionDate.toIso8601String().split('T')[0],
      }),
    );

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body)['record'];
      return Transaction.fromJson(json);
    } else {
      print('❌ Add transaction failed: ${response.statusCode}');
      print('🔽 ${response.body}');
      return null;
    }
  }
}
