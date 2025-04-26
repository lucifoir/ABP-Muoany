import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  AnalysisType _selectedAnalysis = AnalysisType.expenses;

  final List<AnalysisData> _expensesData = [
    AnalysisData('Home', 58.73, 1490000, Colors.blue),
    AnalysisData('Food', 18.30, 465000, Colors.green),
    AnalysisData('Electronics', 10.09, 256000, Colors.orange),
    AnalysisData('Transportation', 7.74, 196000, Colors.red),
    AnalysisData('Entertainment', 2.69, 68000, Colors.purple),
    AnalysisData('Donations', 2.42, 61000, Colors.brown),
  ];

  final List<AnalysisData> _incomeData = [
    AnalysisData('Salary', 85.0, 4500000, Colors.green),
    AnalysisData('Investments', 12.5, 662000, Colors.blueAccent),
    AnalysisData('Freelance', 2.5, 132000, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    final currentData =
        _selectedAnalysis == AnalysisType.expenses
            ? _expensesData
            : _incomeData;

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 20),
            _buildPieChart(currentData),
            const SizedBox(height: 20),
            _buildLegendList(currentData),
          ],
        ),
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
}

enum AnalysisType { expenses, income }

class AnalysisData {
  final String category;
  final double percentage;
  final double amount;
  final Color color;

  AnalysisData(this.category, this.percentage, this.amount, this.color);
}
