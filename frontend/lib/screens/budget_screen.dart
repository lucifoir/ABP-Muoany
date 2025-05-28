import 'package:flutter/material.dart';
import 'package:frontend/widgets/bottom_nav_bar.dart';
import 'package:frontend/screens/add_budget_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/analysis_screen.dart';
import 'package:frontend/screens/account_screen.dart';
import 'package:frontend/services/budget_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int _currentIndex = 2;
  bool _isLoading = true;
  List budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    try {
      final data = await BudgetService.fetchBudgets();
      setState(() {
        budgets = data;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading budgets: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onTap(int index) {
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

  void _confirmDelete(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Budget'),
            content: const Text('Are you sure you want to delete this budget?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final success = await BudgetService.deleteBudget(
                    categoryName,
                  );
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Budget deleted')),
                    );
                    _loadBudgets(); // refresh data
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete budget')),
                    );
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  ...budgets.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildBudgetCard(
                        icon: Icons.category,
                        title: b['category_name'],
                        limit: double.parse(b['limit_amount'].toString()),
                        spent: double.parse(b['spent_amount'].toString()),
                        color: Colors.purple,
                        isOverLimit:
                            double.parse(b['spent_amount'].toString()) >
                            double.parse(b['limit_amount'].toString()),
                      ),
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBudgetScreen()),
          ).then((_) => _loadBudgets());
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 11, 159, 228),
        foregroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildHeader() {
    final total = budgets.fold(
      0.0,
      (sum, b) => sum + double.parse(b['limit_amount'].toString()),
    );
    final spent = budgets.fold(
      0.0,
      (sum, b) => sum + double.parse(b['spent_amount'].toString()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'May, 2025',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  'TOTAL BUDGET',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Rp${total.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            Column(
              children: [
                const Text('TOTAL SPENT', style: TextStyle(color: Colors.grey)),
                Text(
                  'Rp${spent.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCard({
    required IconData icon,
    required String title,
    required double limit,
    required double spent,
    required Color color,
    bool isOverLimit = false,
  }) {
    double remaining = limit - spent;
    double percent = (spent / limit).clamp(0.0, 1.0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed:
                      () => _confirmDelete(
                        context,
                        title,
                      ), // title di sini adalah categoryName
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              'Limit: Rp${limit.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Spent: Rp${spent.toStringAsFixed(0)}',
              style: TextStyle(color: isOverLimit ? Colors.red : Colors.black),
            ),
            Text(
              'Remaining: Rp${remaining < 0 ? 0 : remaining.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverLimit ? Colors.red : Colors.green,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            if (isOverLimit)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '* Limit exceeded',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
