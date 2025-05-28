import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/widgets/bottom_nav_bar.dart';
import 'package:frontend/screens/budget_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/add_transaction_screen.dart';
import 'package:frontend/screens/account_screen.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/services/transaction_service.dart';
import 'dart:math';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  AnalysisType _selectedAnalysis = AnalysisType.expenses;
  int _currentIndex = 1;
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

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountScreen()),
      );
    }
  }

  void _addNewTransaction(BuildContext context) async {
    final newTransaction = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );

    if (newTransaction != null) {
      print('Transaction added: ${newTransaction.toJson()}');
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _transactions
            .where(
              (t) => t.isIncome == (_selectedAnalysis == AnalysisType.income),
            )
            .toList();
    final Map<String, double> totals = {};
    final Map<String, double> rawAmounts = {};

    for (final t in filtered) {
      final key = t.categoryName ?? t.category;
      totals[key] = (totals[key] ?? 0) + t.amount;
    }

    final totalAmount = totals.values.fold(0.0, (a, b) => a + b);
    final data =
        totals.entries.map((entry) {
          final percent =
              totalAmount == 0 ? 0.0 : (entry.value / totalAmount) * 100;
          return AnalysisData(
            entry.key,
            percent,
            entry.value,
            _generateColor(entry.key),
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Analysis')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTypeSelector(),
                    const SizedBox(height: 20),
                    _buildPieChart(data),
                    const SizedBox(height: 20),
                    _buildLegendList(data),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTransaction(context),
        child: const Icon(Icons.add, size: 28),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SegmentedButton<AnalysisType>(
      segments: const [
        ButtonSegment(
          value: AnalysisType.expenses,
          label: Text('Expenses'),
          icon: Icon(Icons.arrow_upward),
        ),
        ButtonSegment(
          value: AnalysisType.income,
          label: Text('Income'),
          icon: Icon(Icons.arrow_downward),
        ),
      ],
      selected: {_selectedAnalysis},
      onSelectionChanged: (Set<AnalysisType> newSelection) {
        setState(() {
          _selectedAnalysis = newSelection.first;
        });
      },
    );
  }

  Widget _buildPieChart(List<AnalysisData> data) {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections:
              data.map((e) {
                return PieChartSectionData(
                  color: e.color,
                  value: e.percentage,
                  title: '${e.percentage.toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildLegendList(List<AnalysisData> data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            leading: Container(width: 20, height: 20, color: item.color),
            title: Text(item.category),
            trailing: Text(
              '${item.percentage.toStringAsFixed(1)}% (Rp${_formatNumber(item.amount)})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(double number) {
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Color _generateColor(String seed) {
    final hash = seed.codeUnits.fold(0, (p, c) => p + c);
    final r = (hash * 37) % 255;
    final g = (hash * 91) % 255;
    final b = (hash * 53) % 255;
    return Color.fromRGBO(r, g, b, 1);
  }
}

enum AnalysisType { expenses, income }

class AnalysisData {
  final String category;
  final double percentage;
  final double amount;
  final Color color;

  AnalysisData(this.category, this.percentage, this.amount, this.color);
}
