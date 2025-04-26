import 'package:flutter/material.dart';
import 'package:test1/screens/add_transaction_screen.dart';
import 'package:test1/widgets/bottom_nav_bar.dart';
import 'package:test1/widgets/summary_card.dart';
import 'package:test1/widgets/transaction_card.dart';
import 'package:test1/models/transaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      category: 'Food',
      amount: -50000,
      isIncome: false,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: '2',
      category: 'Salary',
      amount: 2000000,
      isIncome: true,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dailyTransactions = _groupTransactionsByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            const SummaryCard(
              expenses: 321000,
              income: 1603918,
              periodTitle: 'April 2025',
            ),
            ...dailyTransactions.entries.map(
              (entry) => TransactionCard(
                date: entry.key,
                transactions: entry.value,
                onTap: () => _showTransactionDetails(entry.value),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTransaction(context),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate() {
    return {
      DateTime.now(): _transactions.where((t) => t.isIncome).toList(),
      DateTime.now().subtract(const Duration(days: 1)):
          _transactions.where((t) => !t.isIncome).toList(),
    };
  }

  void _addNewTransaction(BuildContext context) async {
    final newTransaction = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddTransactionScreen(
              onSave: (transaction) => _transactions.add(transaction),
            ),
      ),
    );

    if (newTransaction != null) {
      setState(() => _transactions.add(newTransaction));
    }
  }

  void _showTransactionDetails(List<Transaction> transactions) {
    // Implement transaction details view
  }
}
