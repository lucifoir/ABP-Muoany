import 'package:flutter/material.dart';
import 'package:frontend/widgets/bottom_nav_bar.dart';
import 'package:frontend/screens/add_budget_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/analysis_screen.dart'; 
import 'package:frontend/screens/account_screen.dart'; 

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int _currentIndex = 2; // BudgetScreen index di BottomNavBar

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildBudgetCard(
            icon: Icons.shopping_bag,
            title: 'Clothing',
            limit: 200.0,
            spent: 145.55,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildBudgetCard(
            icon: Icons.movie,
            title: 'Entertainment',
            limit: 120.0,
            spent: 130.15,
            color: Colors.purple,
            isOverLimit: true,
          ),
          const SizedBox(height: 16),
          _buildBudgetCard(
            icon: Icons.fastfood,
            title: 'Snacks',
            limit: 400.0,
            spent: 370.25,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 32),
          _buildNotBudgetedSection(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBudgetScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 11, 159, 228), // Biru muda (kotak FAB)
        foregroundColor: Colors.deepPurple, // Ungu tua (ikon plus)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'January, 2021',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('TOTAL BUDGET', style: TextStyle(color: Colors.grey)),
                Text('\$720.00', style: TextStyle(color: Colors.green)),
              ],
            ),
            Column(
              children: [
                Text('TOTAL SPENT', style: TextStyle(color: Colors.grey)),
                Text('\$645.95', style: TextStyle(color: Colors.red)),
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
                  child: Text(title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Limit: \$${limit.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Spent: \$${spent.toStringAsFixed(2)}',
              style: TextStyle(
                color: isOverLimit ? Colors.red : Colors.black,
              ),
            ),
            Text(
              'Remaining: \$${remaining < 0 ? 0 : remaining.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isOverLimit ? Colors.red : Colors.green),
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

  Widget _buildNotBudgetedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Not budgeted this month',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Bills'),
            trailing: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddBudgetScreen()),
                );
              },
              child: const Text(
                'SET BUDGET',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
