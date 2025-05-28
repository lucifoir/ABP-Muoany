import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/transaction.dart';
import 'package:frontend/services/transaction_service.dart';

enum TransactionType { income, expense }

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _transactionType = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
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
            onPressed: _isSubmitting ? null : _submitForm,
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
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Transaksi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan judul transaksi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Nominal',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan nominal';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan angka yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDateSelector(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade200,
                      foregroundColor: Colors.white, // warna teks & ikon
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
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
      title: const Text('Tanggal'),
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final newTransaction = await TransactionService.addTransaction(
        title: _titleController.text,
        type: _transactionType == TransactionType.income ? 'income' : 'expense',
        amount: double.parse(_amountController.text),
        description: _titleController.text,
        transactionDate: _selectedDate,
      );

      if (newTransaction != null) {
        Navigator.pop(context, newTransaction);
      } else {
        _showError('Gagal menambahkan transaksi');
      }
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
