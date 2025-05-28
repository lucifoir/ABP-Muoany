import 'package:collection/collection.dart'; // For groupBy
import 'package:uuid/uuid.dart'; // For UUID generation

class Transaction {
  final String id;
  final String category;
  final String? categoryName;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String? description;

  Transaction({
    required this.id,
    required this.category,
    this.categoryName,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      category: json['category'] ?? 'Others', // fallback jika tidak ada
      categoryName: json['category_name'] ?? json['category'] ?? 'Others',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      isIncome: json['type'] == 'income',
      date: DateTime.parse(json['transaction_date']).toLocal(),
      // date: DateTime.parse(json['transaction_date']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'category_name': categoryName,
      'amount': amount,
      'type': isIncome ? 'income' : 'expense',
      'transaction_date': date.toIso8601String(),
      'description': description,
    };
  }
}

class DailyTransactions {
  final DateTime date;
  final List<Transaction> transactions;

  DailyTransactions({required this.date, required this.transactions});

  // Fixed: Properly imported groupBy from collection.dart
  static Map<DateTime, List<Transaction>> groupByDate(List<Transaction> list) {
    return groupBy(
      list,
      (t) => DateTime(t.date.year, t.date.month, t.date.day),
    );
  }
}
