import 'package:flutter/material.dart';
import 'dart:math';
import '../screens/design_system_info.dart';
import '../screens/budget_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/debts_screen.dart';
import '../screens/user_screen.dart';

const Color primaryColor = DSColors.primary;
const Color backgroundColor = DSColors.background;
const Color cardColor = DSColors.surface;
const Color accentColor = DSColors.statusWarning;
const Color errorColor = DSColors.statusError;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final String userName = "Usuário Teste";
  double totalBalance = 7890.50;
  double totalBudget = 4000.00;
  double totalSpent = 2500.00;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      _DashboardContent(
        totalBalance: totalBalance,
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        userName: userName,
        onAddTransactionTap: () => _showAddTransactionModal(context),
      ),
      const BudgetScreen(),
      const GoalsScreen(),
      const DebtsScreen(),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: _buildDrawer(context),

      //  NOVA APPBAR AQUI 
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DSColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 28),
            color: primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserScreen()),
              );
            },
          ),
        ],
      ),

      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showAddTransactionModal(context),
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 30),
            )
          : null,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ---------------------------- DRAWER -------------------------------

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),

          ListTile(
            leading: const Icon(Icons.monetization_on, color: Colors.white),
            title: const Text("Orçamento", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),

          ListTile(
            leading: const Icon(Icons.flag, color: Colors.white),
            title: const Text("Metas", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(2);
            },
          ),

          ListTile(
            leading: const Icon(Icons.trending_down, color: Colors.white),
            title: const Text("Dívidas", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(3);
            },
          ),

          const Divider(color: Colors.white24),

          // ⭐ Ainda pode deixar aqui também se quiser:
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text("Usuário", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserScreen()),
                );
              });
            },
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Prismatik Finance",
              style: TextStyle(color: Colors.white54),
            ),
          )
        ],
      ),
    );
  }

  // --------------------------- NAV BAR ------------------------------

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: cardColor,
      unselectedItemColor: DSColors.textSecondary,
      selectedItemColor: primaryColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Orçamento'),
        BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Metas'),
        BottomNavigationBarItem(icon: Icon(Icons.trending_down), label: 'Dívidas'),
      ],
    );
  }

  // ----------------- MODAL DE TRANSAÇÃO ----------------------------

  void _handleTransactionSubmit(String valueText, String type) {
    final double? value = double.tryParse(valueText.replaceAll(',', '.'));
    if (value == null || value <= 0) return;

    setState(() {
      if (type == 'Despesa') {
        totalBalance -= value;
        totalSpent += value;
      } else if (type == 'Receita') {
        totalBalance += value;
      }
    });
  }

  void _showAddTransactionModal(BuildContext context) {
    final TextEditingController valueController = TextEditingController();
    String transactionType = 'Despesa';

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
                'Nova Transação',
                style: DSTextStyles.h2Section,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DSSpacing.lg),

              StatefulBuilder(
                builder: (context, setStateModal) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTypeButton('Despesa', transactionType,
                          (type) => setStateModal(() => transactionType = type)),
                      const SizedBox(width: DSSpacing.lg),
                      _buildTypeButton('Receita', transactionType,
                          (type) => setStateModal(() => transactionType = type)),
                    ],
                  );
                },
              ),

              const SizedBox(height: DSSpacing.lg),
              TextField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: DSTextStyles.modalValue,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: 'R\$ ',
                  labelStyle: TextStyle(color: DSColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DSColors.primary, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: DSColors.accent, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _handleTransactionSubmit(valueController.text, transactionType);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: DSSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: DSBorders.radiusMedium,
                  ),
                ),
                child: const Text(
                  'Salvar Lançamento',
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

  Widget _buildTypeButton(
      String type, String currentType, Function(String) onTap) {
    final isSelected = type == currentType;

    return GestureDetector(
      onTap: () => onTap(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: DSSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor, width: 1),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.black : DSColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class _DashboardContent extends StatelessWidget {
  final double totalBalance;
  final double totalBudget;
  final double totalSpent;
  final String userName;
  final VoidCallback onAddTransactionTap;

  const _DashboardContent({
    required this.totalBalance,
    required this.totalBudget,
    required this.totalSpent,
    required this.userName,
    required this.onAddTransactionTap,
  });

  double get budgetUsedRatio => totalBudget > 0 ? totalSpent / totalBudget : 0;

  String get budgetStatusText =>
      'R\$ ${totalSpent.toStringAsFixed(2).replaceAll('.', ',')} / '
      'R\$ ${totalBudget.toStringAsFixed(2).replaceAll('.', ',')} Gasto';

  void _goToDesignSystem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DesignSystemDemoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 60,
        left: DSSpacing.lg,
        right: DSSpacing.lg,
        bottom: DSSpacing.xlg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Olá, $userName', style: DSTextStyles.titleGreeting),

          const SizedBox(height: DSSpacing.xlg),
          _buildSummaryCard(),

          const SizedBox(height: DSSpacing.xlg),
          _buildAlertsSection(),

          const SizedBox(height: DSSpacing.xlg),
          _buildActionSection(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    Color progressColor = primaryColor;

    if (budgetUsedRatio >= 0.95) progressColor = errorColor;
    else if (budgetUsedRatio >= 0.70) progressColor = accentColor;

    double progressValue = min(budgetUsedRatio, 1.0);

    return Container(
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: DSBorders.radiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saldo Total Disponível',
              style: TextStyle(color: DSColors.textSecondary, fontSize: 16)),

          const SizedBox(height: DSSpacing.sm),
          Text('R\$ ${totalBalance.toStringAsFixed(2).replaceAll('.', ',')}',
              style: DSTextStyles.h1Balance),

          const SizedBox(height: DSSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Resumo Mensal',
                  style: TextStyle(color: DSColors.textSecondary, fontSize: 16)),
              SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation(progressColor),
                    ),
                    Text(
                      '${(budgetUsedRatio * 100).toInt()}%',
                      style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: DSSpacing.sm),
          Text(budgetStatusText, style: DSTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alertas Urgentes', style: DSTextStyles.h2Section),
        const SizedBox(height: DSSpacing.md),

        _buildAlertCard(
          icon: Icons.access_alarm,
          text: 'Vencimento de Conta: Aluguel vence em 2 dias',
          color: accentColor,
        ),

        const SizedBox(height: DSSpacing.md),
        _buildAlertCard(
          icon: Icons.warning_amber,
          text: 'Limite Atingido: 75% do Orçamento de Lazer',
          color: Colors.deepOrange,
        ),

        const SizedBox(height: DSSpacing.md),
        _buildAlertCard(
          icon: Icons.account_balance_wallet,
          text: 'Aviso de Saldo Baixo: Saldo Principal abaixo de R\$ 500',
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: DSBorders.radiusMedium,
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: DSSpacing.md),
          Expanded(
            child: Text(
              text,
              style: DSTextStyles.bodyText,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Próximas Ações', style: DSTextStyles.h2Section),
        const SizedBox(height: DSSpacing.md),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.receipt_long,
                title: 'Lançamentos',
                subtitle: '+ Receita / - Despesa',
                onTap: onAddTransactionTap,
              ),
            ),
            const SizedBox(width: DSSpacing.lg),
            Expanded(
              child: _buildActionCard(
                icon: Icons.track_changes,
                title: 'Meta em Destaque',
                subtitle: 'Viagem Europa - 40%',
                onTap: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: DSSpacing.lg),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.palette,
                title: 'Design System',
                subtitle: 'Ver componentes e estilos',
                onTap: () => _goToDesignSystem(context),
              ),
            ),
            const SizedBox(width: DSSpacing.lg),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DSSpacing.lg),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: DSBorders.radiusMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryColor, size: 30),
            const SizedBox(height: DSSpacing.sm),
            Text(title,
                style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: DSSpacing.xs),
            Text(subtitle, style: DSTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
