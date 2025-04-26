import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test1/models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  final Function(Transaction) onSave;

  const AddTransactionScreen({super.key, required this.onSave});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _transactionType = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Transaction'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: const Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildTypeSelector(),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDateSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SegmentedButton<TransactionType>(
      segments: const [
        ButtonSegment(
          value: TransactionType.expense,
          icon: Icon(Icons.arrow_upward),
          label: Text('Expense'),
        ),
        ButtonSegment(
          value: TransactionType.income,
          icon: Icon(Icons.arrow_downward),
          label: Text('Income'),
        ),
      ],
      selected: {_transactionType},
      onSelectionChanged: (Set<TransactionType> newSelection) {
        setState(() {
          _transactionType = newSelection.first;
        });
      },
    );
  }

  Widget _buildDateSelector() {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Date'),
      subtitle: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() => _selectedDate = pickedDate);
        }
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTransaction = Transaction(
        id: DateTime.now().toString(),
        category: _categoryController.text,
        amount:
            double.parse(_amountController.text) *
            (_transactionType == TransactionType.income ? 1 : -1),
        date: _selectedDate,
        isIncome: _transactionType == TransactionType.income,
      );

      widget.onSave(newTransaction);
      Navigator.pop(context);
    }
  }
}

enum TransactionType { income, expense }
