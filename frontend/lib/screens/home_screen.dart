import 'package:flutter/material.dart';
import 'package:frontend/screens/add_transaction_screen.dart';
import 'package:frontend/widgets/bottom_nav_bar.dart';
import 'package:frontend/widgets/summary_card.dart';
import 'package:frontend/widgets/transaction_card.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/screens/analysis_screen.dart';
import 'package:frontend/screens/budget_screen.dart';
import 'package:frontend/screens/account_screen.dart';
// import 'package:frontend/screens/account_screen.dart'; // Kalau sudah ada nanti

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

  void _onNavItemTapped(int index) {
    if (index == 0) {
      // Stay di HomeScreen
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnalysisPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BudgetScreen()),
      );
    } else if (index == 3) {
      // Belum ada AccountScreen, kasih info dulu
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
      );
    }
  }

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
        onTap: _onNavItemTapped,
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
        builder: (_) => AddTransactionScreen(
          onSave: (transaction) => _transactions.add(transaction),
        ),
      ),
    );

    if (newTransaction != null) {
      setState(() => _transactions.add(newTransaction));
    }
  }

  void _showTransactionDetails(List<Transaction> transactions) {
    // Implementasi nanti kalau mau lihat detail transaksi
  }
}
