import 'package:collection/collection.dart'; // For groupBy
import 'package:uuid/uuid.dart'; // For UUID generation

class Transaction {
  final String id;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;

  Transaction({
    String? id,
    required this.category,
    required double amount,
    this.isIncome = false,
    DateTime? date,
  })  : id = id ?? const Uuid().v4(), // Fixed: Added Uuid()
        amount = amount.abs(),
        date = date ?? DateTime.now();

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        category: json['category'],
        amount: json['amount'],
        isIncome: json['isIncome'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'amount': amount,
        'isIncome': isIncome,
        'date': date.toIso8601String(),
      };
}

class DailyTransactions {
  final DateTime date;
  final List<Transaction> transactions;

  DailyTransactions({
    required this.date,
    required this.transactions,
  });

  // Fixed: Properly imported groupBy from collection.dart
  static Map<DateTime, List<Transaction>> groupByDate(List<Transaction> list) {
    return groupBy(list, (t) => DateTime(t.date.year, t.date.month, t.date.day));
  }
}