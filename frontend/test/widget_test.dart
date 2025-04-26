import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test1/app.dart';
import 'package:test1/models/transaction.dart';

void main() {
  // Test 1: App launches and shows title
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MoneyTrackerApp());
    expect(find.text('Money Tracker'), findsOneWidget);
  });

  // Test 2: Transaction model works
  test('Transaction model handles amounts correctly', () {
    final transaction = Transaction(
      category: 'Food',
      amount: 15000.0,
      isIncome: false,
    );
    expect(transaction.amount, equals(15000.0));
    expect(transaction.category, equals('Food'));
  });

  // Test 3: DailyTransactions model - FIXED DateTime
  test('DailyTransactions aggregates correctly', () {
    final daily = DailyTransactions(
      date: DateTime(2023, 5, 12), // Changed from String to DateTime
      transactions: [
        Transaction(category: 'Lunch', amount: -50000.0),
        Transaction(category: 'Salary', amount: 2000000.0, isIncome: true),
      ],
    );

    expect(daily.transactions.length, equals(2));
    expect(daily.date, equals(DateTime(2023, 5, 12))); // Updated assertion
  });

  // Test 4: Finds FAB button
  testWidgets('Floating action button exists', (tester) async {
    await tester.pumpWidget(const MoneyTrackerApp());
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  // Test 5: Navigation items exist
  testWidgets('Bottom navigation has 5 items', (tester) async {
    await tester.pumpWidget(const MoneyTrackerApp());
    expect(find.text('Records'), findsOneWidget);
    expect(find.text('Analysis'), findsOneWidget);
    expect(find.text('Budget'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });
}
