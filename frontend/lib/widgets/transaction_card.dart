import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test1/models/transaction.dart'; // Assume this exists

class TransactionCard extends StatelessWidget {
  final DateTime date; // Changed from String to DateTime
  final List<Transaction> transactions;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.date,
    required this.transactions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (income, expense) = _calculateTotals();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy').format(date), // Formatted date
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      if (expense > 0)
                        _buildTotalBadge('Expenses', expense, Colors.red),
                      if (income > 0)
                        _buildTotalBadge('Income', income, Colors.green),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              // Transaction List
              ...transactions
                  .map((t) => _buildTransactionRow(t, theme))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  (double income, double expense) _calculateTotals() {
    double income = 0;
    double expense = 0;

    for (final t in transactions) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount.abs();
      }
    }

    return (income, expense);
  }

  Widget _buildTotalBadge(String label, double amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: ${_formatCurrency(amount)}',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTransactionRow(Transaction t, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              t.category,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${t.amount > 0 ? '+' : ''}${_formatCurrency(t.amount)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: t.isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(decimalDigits: 0, symbol: '').format(amount);
  }
}
