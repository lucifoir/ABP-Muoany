import 'package:flutter/material.dart';
import 'package:frontend/screens/add_transaction_screen.dart';
import 'package:frontend/widgets/bottom_nav_bar.dart';
import 'package:frontend/widgets/summary_card.dart';
import 'package:frontend/widgets/transaction_card.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/screens/analysis_screen.dart';
import 'package:frontend/screens/budget_screen.dart';
import 'package:frontend/screens/account_screen.dart';
import 'package:frontend/services/transaction_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final fetched = await TransactionService.fetchTransactions();
      setState(() {
        _transactions = fetched;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to fetch transactions: $e');
      setState(() => _isLoading = false);
    }
  }

  

  double get totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  void _onNavItemTapped(int index) {
    if (index == 0) return;
    if (index == 1) {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupTransactionsByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    SummaryCard(
                      expenses: totalExpense,
                      income: totalIncome,
                      periodTitle: 'April 2025',
                    ),
                    ...grouped.entries.map(
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
    return DailyTransactions.groupByDate(_transactions);
  }

  void _addNewTransaction(BuildContext context) async {
    final newTransaction = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );

    if (newTransaction != null) {
      setState(() => _transactions.add(newTransaction));
    }
  }

  void _showTransactionDetails(List<Transaction> transactions) {
    // Implementasi nanti kalau mau lihat detail transaksi
  }
}
