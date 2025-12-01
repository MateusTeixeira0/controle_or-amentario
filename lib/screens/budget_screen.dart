import 'package:flutter/material.dart';
import 'design_system_info.dart'; 

// Dados Mock (Temporários) para o Orçamento
class BudgetData {
  final String category;
  final double allocated;
  final double spent;
  final IconData icon;
  final Color color;

  double get remaining => allocated - spent;
  double get percentageSpent => spent / allocated;

  BudgetData({
    required this.category,
    required this.allocated,
    required this.spent,
    required this.icon,
    required this.color,
  });
}

// Lista de Orçamentos Mock
final List<BudgetData> mockBudgets = [
  BudgetData(
    category: 'Moradia',
    allocated: 2000.00,
    spent: 1850.00,
    icon: Icons.home,
    color: Colors.blueAccent,
  ),
  BudgetData(
    category: 'Alimentação',
    allocated: 1200.00,
    spent: 980.00,
    icon: Icons.fastfood,
    color: DSColors.statusWarning,
  ),
  BudgetData(
    category: 'Transporte',
    allocated: 400.00,
    spent: 410.00, // Estourou o orçamento
    icon: Icons.directions_car,
    color: DSColors.statusError,
  ),
  BudgetData(
    category: 'Lazer',
    allocated: 500.00,
    spent: 150.00,
    icon: Icons.sports_esports,
    color: DSColors.primary,
  ),
];

// WIDGET PRINCIPAL
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calcula o total gasto e total alocado para o cabeçalho
    final double totalAllocated = mockBudgets.fold(0, (sum, item) => sum + item.allocated);
    final double totalSpent = mockBudgets.fold(0, (sum, item) => sum + item.spent);
    final double totalRemaining = totalAllocated - totalSpent;
    
    return Scaffold(
      backgroundColor: DSColors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          // Cabeçalho e Título
          SliverAppBar(
            backgroundColor: DSColors.surface,
            floating: true,
            pinned: true,
            centerTitle: false,
            title: const Text('Orçamentos Mensais', style: DSTextStyles.h2Section),
            foregroundColor: DSColors.textPrimary,
          ),
          
          // Card de Resumo Global do Orçamento
          SliverToBoxAdapter(
            child: _buildBudgetSummaryCard(totalAllocated, totalSpent, totalRemaining),
          ),

          // Lista de Orçamentos por Categoria
          SliverPadding(
            padding: const EdgeInsets.all(DSSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildBudgetCategoryItem(mockBudgets[index]);
                },
                childCount: mockBudgets.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // WIDGETS AUXILIARES
  // ----------------------------------------------------------------------

  Widget _buildBudgetSummaryCard(double allocated, double spent, double remaining) {
    Color remainingColor = remaining >= 0 ? DSColors.primary : DSColors.statusError;
    String remainingText = remaining >= 0 ? 'Restante' : 'Estouro';

    return Container(
      margin: const EdgeInsets.all(DSSpacing.lg),
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: DSBorders.radiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Orçamento Total para o Mês', style: DSTextStyles.bodyText),
          const SizedBox(height: DSSpacing.sm),
          
          _buildSummaryRow('Alocado:', allocated, DSColors.textPrimary),
          _buildSummaryRow('Gasto:', spent, DSColors.textSecondary),
          const Divider(color: DSColors.textSecondary),
          _buildSummaryRow(remainingText, remaining.abs(), remainingColor),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DSSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: DSTextStyles.bodyText.copyWith(color: color)),
          Text(
            'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
            style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCategoryItem(BudgetData budget) {
    // Define a cor da barra com base no status (estouro ou perto)
    Color progressBarColor = budget.color;
    if (budget.remaining < 0) {
      progressBarColor = DSColors.statusError; // Estourou
    } else if (budget.percentageSpent >= 0.85) {
      progressBarColor = DSColors.statusWarning; // Quase estourou
    }

    // Calcula a porcentagem para exibição
    String percentageText = '${(budget.percentageSpent * 100).toStringAsFixed(0)}%';

    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(DSSpacing.lg),
        decoration: BoxDecoration(
          color: DSColors.surface,
          borderRadius: DSBorders.radiusMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(budget.icon, color: budget.color),
                const SizedBox(width: DSSpacing.md),
                Text(budget.category, style: DSTextStyles.h2Section),
              ],
            ),
            const SizedBox(height: DSSpacing.md),
            
            // Barra de Progresso
            ClipRRect(
              borderRadius: DSBorders.radiusSmall,
              child: LinearProgressIndicator(
                value: budget.percentageSpent,
                backgroundColor: DSColors.textSecondary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                minHeight: DSSpacing.sm,
              ),
            ),
            const SizedBox(height: DSSpacing.sm),

            // Detalhes Gasto vs. Alocado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gasto: R\$ ${budget.spent.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: DSTextStyles.caption.copyWith(color: DSColors.textSecondary),
                ),
                Text(
                  'Alocado: R\$ ${budget.allocated.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: DSTextStyles.caption.copyWith(color: DSColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: DSSpacing.sm),
            
            // Valor Restante/Estouro
            Text(
              budget.remaining >= 0 
                ? 'Resta: R\$ ${budget.remaining.toStringAsFixed(2).replaceAll('.', ',')}'
                : 'Estouro: R\$ ${budget.remaining.abs().toStringAsFixed(2).replaceAll('.', ',')}',
              style: DSTextStyles.bodyText.copyWith(color: progressBarColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: DSSpacing.xs),
            Text(
              '${percentageText} utilizado',
              style: DSTextStyles.caption.copyWith(color: progressBarColor),
            ),
          ],
        ),
      ),
    );
  }
}