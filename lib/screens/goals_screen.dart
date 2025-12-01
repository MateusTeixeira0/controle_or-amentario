import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_system_info.dart'; 


const Color primaryColor = DSColors.primary;
const Color cardColor = DSColors.surface;


// Dados da Meta
class GoalData {
  final String title;
  final double targetAmount;
  final double savedAmount;
  final IconData icon;
  final Color color;
  final String deadline; 
  
  double get remainingAmount => targetAmount - savedAmount;
  double get progressRatio => targetAmount > 0 ? savedAmount / targetAmount : 0.0;

  GoalData({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.icon,
    required this.color,
    required this.deadline,
  });
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  
  // Lista de Metas (Agora no State)
  List<GoalData> _goals = [
    GoalData(
      title: 'Reserva de Emergência',
      targetAmount: 15000.00,
      savedAmount: 8500.00,
      icon: Icons.security,
      color: DSColors.statusWarning, 
      deadline: 'Sem Prazo',
    ),
    GoalData(
      title: 'Viagem Europa',
      targetAmount: 8000.00,
      savedAmount: 3200.00,
      icon: Icons.flight_takeoff,
      color: DSColors.accent, 
      deadline: 'Dezembro/2026',
    ),
    GoalData(
      title: 'Troca de Carro (Entrada)',
      targetAmount: 30000.00,
      savedAmount: 1000.00,
      icon: Icons.directions_car_filled,
      color: Colors.redAccent, 
      deadline: 'Janeiro/2027',
    ),
  ];

 

  void _handleAddGoal(GoalData newGoal) {
    setState(() {
      _goals.add(newGoal);
    });
  }

  void _showAddGoalModal(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final savedController = TextEditingController();
    final deadlineController = TextEditingController();
    
    // Simulação de Seleção de Ícone/Cor (Poderia ser um selector mais complexo)
    IconData selectedIcon = Icons.star;
    Color selectedColor = primaryColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: DSSpacing.lg,
            left: DSSpacing.lg,
            right: DSSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Criar Nova Meta',
                style: DSTextStyles.h2Section,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DSSpacing.lg),

              TextField( 
                controller: titleController, 
                decoration: _inputDecoration('Título da Meta'),
                style: DSTextStyles.bodyText,
              ),
              const SizedBox(height: DSSpacing.md),

              TextField( 
                controller: targetController, 
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                decoration: _inputDecoration('Valor Total da Meta (R\$)'),
                style: DSTextStyles.bodyText,
              ),
              const SizedBox(height: DSSpacing.md),
              
              TextField( 
                controller: savedController, 
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                decoration: _inputDecoration('Valor Já Economizado (R\$)'),
                style: DSTextStyles.bodyText,
              ),
              const SizedBox(height: DSSpacing.md),
              
              TextField( 
                controller: deadlineController, 
                decoration: _inputDecoration('Prazo (Ex: Dez/2026)'),
                style: DSTextStyles.bodyText,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final target = double.tryParse(targetController.text) ?? 0.0;
                  final saved = double.tryParse(savedController.text) ?? 0.0;
                  final deadline = deadlineController.text.trim().isEmpty ? 'Sem Prazo' : deadlineController.text.trim();

                  if (title.isNotEmpty && target > 0) {
                    final newGoal = GoalData(
                      title: title,
                      targetAmount: target,
                      savedAmount: saved,
                      deadline: deadline,
                      icon: selectedIcon, 
                      color: selectedColor, 
                    );
                    _handleAddGoal(newGoal);
                    Navigator.pop(context);
                  } else {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, preencha o Título e o Valor Total corretamente.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: DSSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: DSBorders.radiusMedium,
                  ),
                ),
                child: const Text(
                  'Salvar Nova Meta',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: DSColors.textSecondary),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: DSColors.textSecondary, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: DSColors.accent, width: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final double totalRemainingToSave = _goals.fold(0, (sum, item) => sum + item.remainingAmount);

    return Scaffold(
      backgroundColor: DSColors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: cardColor,
            floating: true,
            pinned: true,
            centerTitle: false,
            title: const Text('Metas Financeiras', style: DSTextStyles.h2Section),
            foregroundColor: DSColors.textPrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _showAddGoalModal(context), 
              ),
              const SizedBox(width: DSSpacing.sm),
            ],
          ),
          
          
          SliverToBoxAdapter(
            child: _buildGoalsSummaryCard(totalRemainingToSave),
          ),

          
          SliverPadding(
            padding: const EdgeInsets.all(DSSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildGoalItem(_goals[index]);
                },
                childCount: _goals.length,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildGoalsSummaryCard(double totalRemaining) {
    return Container(
      margin: const EdgeInsets.all(DSSpacing.lg),
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: DSBorders.radiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Falta Economizar para TODAS as Metas', style: DSTextStyles.bodyText),
          const SizedBox(height: DSSpacing.sm),
          Text(
            'R\$ ${totalRemaining.toStringAsFixed(2).replaceAll('.', ',')}',
            style: DSTextStyles.titleGreeting.copyWith(color: primaryColor),
          ),
          const Divider(color: DSColors.textSecondary),
          Text(
            '${_goals.length} metas ativas',
            style: DSTextStyles.caption.copyWith(color: DSColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(GoalData goal) {
   
    Color progressBarColor = goal.color;
    
   
    String percentageText = '${(goal.progressRatio * 100).toStringAsFixed(1)}%';

    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(DSSpacing.lg),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: DSBorders.radiusMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(goal.icon, color: goal.color),
                    const SizedBox(width: DSSpacing.md),
                    Text(goal.title, style: DSTextStyles.h2Section),
                  ],
                ),
                Text(
                  percentageText,
                  style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: progressBarColor),
                ),
              ],
            ),
            const SizedBox(height: DSSpacing.lg),
            
          
            ClipRRect(
              borderRadius: DSBorders.radiusSmall,
              child: LinearProgressIndicator(
                value: goal.progressRatio,
                backgroundColor: DSColors.textSecondary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                minHeight: DSSpacing.md,
              ),
            ),
            const SizedBox(height: DSSpacing.sm),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salvo: R\$ ${goal.savedAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: DSTextStyles.bodyText.copyWith(color: DSColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Meta Total: R\$ ${goal.targetAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: DSTextStyles.bodyText.copyWith(color: DSColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: DSSpacing.sm),
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Falta R\$ ${goal.remainingAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: DSTextStyles.caption.copyWith(color: progressBarColor),
                ),
                Text(
                  'Prazo: ${goal.deadline}',
                  style: DSTextStyles.caption.copyWith(color: DSColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}