import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For currency formatting

class SummaryCard extends StatelessWidget {
  final double expenses;
  final double income;
  final String periodTitle;
  final bool isSmallScreen;

  const SummaryCard({
    super.key,
    required this.expenses,
    required this.income,
    required this.periodTitle,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final balance = income - expenses;
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$periodTitle Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 300;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryItem(
                      context,
                      'Expenses',
                      expenses,
                      Colors.red,
                      compact: isCompact,
                    ),
                    _buildSummaryItem(
                      context,
                      'Income',
                      income,
                      Colors.green,
                      compact: isCompact,
                    ),
                    _buildSummaryItem(
                      context,
                      'Balance',
                      balance,
                      theme.primaryColor,
                      compact: isCompact,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    double value,
    Color color, {
    required bool compact,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          _formatCurrency(value),
          style: textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: compact ? 14 : 16,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(decimalDigits: 0, symbol: '').format(amount);
  }
}
