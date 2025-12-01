import 'package:flutter/material.dart';
import 'design_system_info.dart'; 

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final List<Map<String, dynamic>> _debts = [
    {'title': 'Cartão de Crédito', 'amount': 1200.00, 'paid': false},
    {'title': 'Empréstimo Pessoal', 'amount': 800.00, 'paid': true},
    {'title': 'Conta de Luz', 'amount': 200.00, 'paid': false},
  ];

  void _addDebt(String title, double amount) {
    setState(() {
      _debts.add({'title': title, 'amount': amount, 'paid': false});
    });
  }

  void _togglePaid(int index) {
    setState(() {
      _debts[index]['paid'] = !_debts[index]['paid'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: AppBar(
        title: const Text('Dívidas'),
        backgroundColor: DSColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(DSSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minhas Dívidas',
              style: DSTextStyles.h2Section,
            ),
            const SizedBox(height: DSSpacing.md),
            Expanded(
              child: ListView.builder(
                itemCount: _debts.length,
                itemBuilder: (context, index) {
                  final debt = _debts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: DSSpacing.md),
                    padding: const EdgeInsets.all(DSSpacing.md),
                    decoration: BoxDecoration(
                      color: DSColors.surface,
                      borderRadius: DSBorders.radiusMedium,
                      border: Border(
                        left: BorderSide(
                          color: debt['paid']
                              ? DSColors.statusSuccess
                              : DSColors.statusError,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              debt['title'],
                              style: TextStyle(
                                color: debt['paid']
                                    ? DSColors.statusSuccess
                                    : DSColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'R\$ ${debt['amount'].toStringAsFixed(2).replaceAll('.', ',')}',
                              style: TextStyle(
                                color: debt['paid']
                                    ? DSColors.statusSuccess
                                    : DSColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            debt['paid']
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: debt['paid']
                                ? DSColors.statusSuccess
                                : DSColors.textSecondary,
                          ),
                          onPressed: () => _togglePaid(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DSColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _showAddDebtModal(context),
      ),
    );
  }

  void _showAddDebtModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: DSColors.surface,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adicionar Dívida', style: DSTextStyles.h2Section),
              const SizedBox(height: DSSpacing.md),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: DSColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DSColors.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DSColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: DSSpacing.md),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  labelStyle: TextStyle(color: DSColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DSColors.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DSColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: DSSpacing.lg),
              ElevatedButton(
                onPressed: () {
                  final double? value = double.tryParse(
                    amountController.text.replaceAll(',', '.'),
                  );
                  if (titleController.text.isNotEmpty && value != null) {
                    _addDebt(titleController.text, value);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DSColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: DSSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: DSBorders.radiusMedium,
                  ),
                ),
                child: const Text(
                  'Salvar Dívida',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: DSSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
