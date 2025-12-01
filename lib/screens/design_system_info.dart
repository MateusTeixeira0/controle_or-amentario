import 'package:flutter/material.dart';

// ======================================================================
// DESIGN SYSTEM - design_system_info.dart (UPDATED)
// ======================================================================
// Dark mode focused design system for Prismatik Finance App.
// Contains colors, typography, spacing, borders and reusable components.
// ======================================================================

// ----------------------------------------------------------------------
// 1. CORE: COLORS, TYPOGRAPHY, SPACING, BORDERS
// ----------------------------------------------------------------------
class DSColors {
  // Thematic
  static const Color primary = Color(0xFF00C897); // Verde Sucesso
  static const Color background = Color(0xFF121212); // Fundo Escuro
  static const Color surface = Color(0xFF1E1E1E); // Cards / Surfaces
  static const Color accent = Color(0xFF00BCD4); // Ciano

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);

  // Neutrals
  static const Color neutralDivider = Color(0xFF333333);

  // Status
  static const Color statusSuccess = primary;
  static const Color statusError = Color(0xFFEE4444);
  static const Color statusWarning = Color(0xFFFFCC00);
}

class DSTextStyles {
  static const TextStyle h1Balance = TextStyle(
    color: DSColors.textPrimary,
    fontSize: 36,
    fontWeight: FontWeight.w900,
    fontFamily: 'Roboto',
  );

  static const TextStyle titleGreeting = TextStyle(
    color: DSColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static const TextStyle h2Section = TextStyle(
    color: DSColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyText = TextStyle(
    color: DSColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );

  static const TextStyle caption = TextStyle(
    color: DSColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'Roboto',
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
  );

  static const TextStyle microText = TextStyle(
    color: DSColors.textSecondary,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );

  static const TextStyle modalValue = TextStyle(
    color: DSColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );
}

class DSSpacing {
  static const double xlg = 24.0;
  static const double lg = 16.0;
  static const double md = 12.0;
  static const double sm = 8.0;
  static const double xs = 4.0;
}

class DSBorders {
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(20.0));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(15.0));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(10.0));
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(5.0));
}

// ----------------------------------------------------------------------
// 2. REUSABLE COMPONENTS
// ----------------------------------------------------------------------

// 2.1 Primary Button
class DSPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DSPrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: DSColors.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: DSBorders.radiusMedium),
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.md),
      ),
      child: Text(text.toUpperCase(), style: DSTextStyles.buttonText),
    );
  }
}

// 2.2 Generic Card
class DSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const DSCard({super.key, required this.child, this.padding = const EdgeInsets.all(DSSpacing.lg), this.margin = const EdgeInsets.only(bottom: DSSpacing.md)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: DSColors.surface,
        borderRadius: DSBorders.radiusLarge,
        border: Border.all(color: DSColors.neutralDivider),
      ),
      child: child,
    );
  }
}

// 2.3 Balance Card (with visibility toggle)
class DSBalanceCard extends StatefulWidget {
  final double balance;

  const DSBalanceCard({super.key, required this.balance});

  @override
  State<DSBalanceCard> createState() => _DSBalanceCardState();
}

class _DSBalanceCardState extends State<DSBalanceCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DSSpacing.lg),
      decoration: BoxDecoration(color: DSColors.surface, borderRadius: DSBorders.radiusLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Saldo Atual', style: DSTextStyles.caption),
            GestureDetector(
              onTap: () => setState(() => _isVisible = !_isVisible),
              child: Icon(_isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: DSColors.textSecondary, size: 20),
            ),
          ]),
          const SizedBox(height: DSSpacing.sm),
          _isVisible
              ? Text('R\$ ${widget.balance.toStringAsFixed(2).replaceAll('.', ',')}', style: DSTextStyles.h1Balance.copyWith(color: widget.balance >= 0 ? DSColors.statusSuccess : DSColors.statusError))
              : Text('R\$ ---,--', style: DSTextStyles.h1Balance),
          const SizedBox(height: DSSpacing.sm),
          Text('Última atualização: Hoje', style: DSTextStyles.caption),
        ],
      ),
    );
  }
}

// 2.4 Transaction Tile
class DSTransactionTile extends StatelessWidget {
  final String description;
  final String category;
  final double amount;
  final IconData icon;

  const DSTransactionTile({super.key, required this.description, required this.category, required this.amount, required this.icon});

  @override
  Widget build(BuildContext context) {
    final bool isExpense = amount < 0;
    final Color amountColor = isExpense ? DSColors.statusError : DSColors.statusSuccess;
    final String amountText = isExpense ? '- R\$ ${(-amount).toStringAsFixed(2).replaceAll('.', ',')}' : '+ R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.md),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(DSSpacing.sm), decoration: BoxDecoration(color: DSColors.surface, borderRadius: DSBorders.radiusMedium), child: Icon(icon, color: amountColor, size: 24)),
        const SizedBox(width: DSSpacing.lg),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(description, style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
          Text(category, style: DSTextStyles.caption),
        ])),
        Text(amountText, style: DSTextStyles.bodyText.copyWith(color: amountColor, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

// 2.5 Text Input
class DSTextInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;

  const DSTextInput({super.key, required this.label, required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: DSTextStyles.caption.copyWith(color: DSColors.accent)),
      const SizedBox(height: DSSpacing.sm),
      TextFormField(
        style: DSTextStyles.bodyText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: DSTextStyles.bodyText.copyWith(color: DSColors.textSecondary.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: DSColors.textSecondary),
          filled: true,
          fillColor: DSColors.surface,
          border: OutlineInputBorder(borderRadius: DSBorders.radiusMedium, borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: DSBorders.radiusMedium, borderSide: BorderSide(color: DSColors.neutralDivider, width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: DSBorders.radiusMedium, borderSide: BorderSide(color: DSColors.accent, width: 2.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: DSSpacing.md, horizontal: DSSpacing.lg),
        ),
      ),
    ]);
  }
}

// 2.6 Category Pill
class DSCategoryPill extends StatelessWidget {
  final String text;
  final bool isSelected;

  const DSCategoryPill({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected ? DSColors.primary : DSColors.surface;
    final Color textColor = isSelected ? Colors.black : DSColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: DSBorders.radiusLarge, border: isSelected ? null : Border.all(color: DSColors.neutralDivider)),
      child: Text(text, style: DSTextStyles.bodyText.copyWith(color: textColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

// 2.7 Navigation Bar
class DSNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DSNavigationBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: DSColors.surface,
      selectedItemColor: DSColors.primary,
      unselectedItemColor: DSColors.textSecondary,
      selectedLabelStyle: DSTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
      unselectedLabelStyle: DSTextStyles.caption,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Análise'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Contas'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// NEW: 2.8 Progress Bar
class DSProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final Color color;
  final String label;

  const DSProgressBar({super.key, required this.progress, this.color = DSColors.primary, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: DSTextStyles.caption),
      const SizedBox(height: DSSpacing.xs),
      ClipRRect(borderRadius: DSBorders.radiusSmall, child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0), backgroundColor: DSColors.neutralDivider, color: color, minHeight: 8)),
    ]);
  }
}

// ----------------------------------------------------------------------
// NEW: 2.9 Debt Tile
class DSDebtTile extends StatelessWidget {
  final String creditor;
  final double total;
  final double paid;
  final DateTime dueDate;

  const DSDebtTile({super.key, required this.creditor, required this.total, required this.paid, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final double progress = (total == 0) ? 0 : (paid / total);
    final bool isLate = DateTime.now().isAfter(dueDate);

    return DSCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(creditor, style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
        Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: DSTextStyles.bodyText.copyWith(color: DSColors.textPrimary)),
      ]),
      const SizedBox(height: DSSpacing.sm),
      DSProgressBar(progress: progress.clamp(0.0, 1.0), color: isLate ? DSColors.statusError : DSColors.primary, label: 'Pago: R\$ ${paid.toStringAsFixed(2).replaceAll('.', ',')}'),
      const SizedBox(height: DSSpacing.sm),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Vencimento: ${dueDate.day}/${dueDate.month}/${dueDate.year}', style: DSTextStyles.caption),
        if (isLate)
          Text('Atrasada', style: DSTextStyles.caption.copyWith(color: DSColors.statusError))
        else
          Text('${(progress * 100).toStringAsFixed(0)}% quitada', style: DSTextStyles.caption),
      ])
    ]));
  }
}

// ----------------------------------------------------------------------
// NEW: 2.10 Alert Banner
class DSAlertBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const DSAlertBanner({super.key, required this.message, this.icon = Icons.warning_amber_rounded, this.color = DSColors.statusWarning});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: DSSpacing.md),
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: DSBorders.radiusMedium, border: Border.all(color: color, width: 1.2)),
      child: Row(children: [Icon(icon, color: color), const SizedBox(width: DSSpacing.md), Expanded(child: Text(message, style: DSTextStyles.bodyText.copyWith(color: color))) ]),
    );
  }
}

// ----------------------------------------------------------------------
// NEW: 2.11 Modal helper
Future<void> DSModalBottomSheet({required BuildContext context, required Widget content, String? title}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: DSColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(left: DSSpacing.lg, right: DSSpacing.lg, top: DSSpacing.lg, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (title != null) Padding(padding: const EdgeInsets.only(bottom: DSSpacing.md), child: Text(title, style: DSTextStyles.h2Section)),
          content,
          const SizedBox(height: DSSpacing.lg),
        ]),
      );
    },
  );
}


class DesignSystemDemoScreen extends StatefulWidget {
  const DesignSystemDemoScreen({super.key});

  @override
  State<DesignSystemDemoScreen> createState() => _DesignSystemDemoScreenState();
}

class _DesignSystemDemoScreenState extends State<DesignSystemDemoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _navBarIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: AppBar(
        title: const Text('System Finance: Design System'),
        backgroundColor: DSColors.surface,
        foregroundColor: DSColors.textPrimary,
        bottom: TabBar(controller: _tabController, indicatorColor: DSColors.primary, labelColor: DSColors.primary, unselectedLabelColor: DSColors.textSecondary, tabs: const [Tab(text: 'Cores', icon: Icon(Icons.palette)), Tab(text: 'Tipografia', icon: Icon(Icons.title)), Tab(text: 'Componentes', icon: Icon(Icons.widgets))]),
      ),
      body: TabBarView(controller: _tabController, children: [_ColorsPage(), _TypographyPage(), _ComponentsPage()]),
      floatingActionButton: _tabController.index == 2 ? FloatingActionButton(onPressed: () {}, backgroundColor: DSColors.accent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: DSBorders.radiusLarge), child: const Icon(Icons.add)) : null,
      bottomNavigationBar: DSNavigationBar(currentIndex: _navBarIndex, onTap: (index) => setState(() => _navBarIndex = index)),
    );
  }
}

// ----------------------------------------------------------------------
//  Colors
class _ColorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(DSSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Paleta Principal', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      _buildColorSwatch(DSColors.primary, 'Primary', 'Sucesso/Ação (Receita)'),
      _buildColorSwatch(DSColors.background, 'Background', 'Fundo Principal'),
      _buildColorSwatch(DSColors.surface, 'Surface', 'Cards/NavBar/Appbar'),
      _buildColorSwatch(DSColors.accent, 'Accent', 'Foco/Input/FAB'),
      const SizedBox(height: DSSpacing.xlg),
      const Text('Textos e Neutras', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      _buildColorSwatch(DSColors.textPrimary, 'Text Primary', 'Títulos/Valores'),
      _buildColorSwatch(DSColors.textSecondary, 'Text Secondary', 'Descrições/Legendas'),
      _buildColorSwatch(DSColors.neutralDivider, 'Neutral Divider', 'Linhas de Separação'),
      const SizedBox(height: DSSpacing.xlg),
      const Text('Status', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      _buildColorSwatch(DSColors.statusError, 'Status Error', 'Perigo/Estouro (Despesa)'),
      _buildColorSwatch(DSColors.statusWarning, 'Status Warning', 'Atenção/Alerta'),
    ]));
  }

  Widget _buildColorSwatch(Color color, String name, String usage) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: DSSpacing.sm), child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color, borderRadius: DSBorders.radiusSmall, border: color.value == DSColors.textPrimary.value || color.value == DSColors.background.value ? Border.all(color: DSColors.textSecondary.withOpacity(0.5), width: 0.5) : null)),
      const SizedBox(width: DSSpacing.lg),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: DSTextStyles.bodyText), Text('#${color.value.toRadixString(16).substring(2).toUpperCase()} - $usage', style: DSTextStyles.caption)]),
    ]));
  }
}

// ----------------------------------------------------------------------
// 5. SUB-PAGE: Typography
class _TypographyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(DSSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Hierarquia Tipográfica', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      _buildTypographyExample('R\$ 12.345,67', DSTextStyles.h1Balance, 'H1 - Saldo Total (36px)'),
      _buildTypographyExample('Olá, Usuário', DSTextStyles.titleGreeting, 'Título de Saudação (28px)'),
      _buildTypographyExample('Alertas Urgentes', DSTextStyles.h2Section, 'H2 - Título de Seção (20px)'),
      _buildTypographyExample('Corpo de texto padrão', DSTextStyles.bodyText, 'Body (14px)'),
      _buildTypographyExample('Descrição curta ou legenda', DSTextStyles.caption, 'Caption (12px)'),
      _buildTypographyExample('BOTÃO DE AÇÃO', DSTextStyles.buttonText, 'Button Text (15px)'),
      const SizedBox(height: DSSpacing.xlg),
      const Text('Casos Específicos', style: DSTextStyles.h2Section),
      _buildTypographyExample('R\$ 999,99', DSTextStyles.modalValue, 'Modal Value Input (32px)'),
      _buildTypographyExample('10/JAN/2025', DSTextStyles.microText, 'Micro Text (10px - Gráficos/Datas)'),
    ]));
  }

  Widget _buildTypographyExample(String text, TextStyle style, String label) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(text, style: style), Text(label, style: DSTextStyles.caption.copyWith(color: DSColors.accent)), const SizedBox(height: DSSpacing.lg)]);
  }
}

// ----------------------------------------------------------------------
//Components 
class _ComponentsPage extends StatelessWidget {
  const _ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(DSSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('1. Cartão de Saldo (DSBalanceCard)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      const DSBalanceCard(balance: -123.45),
      const SizedBox(height: DSSpacing.xlg),
      const Text('2. Ações e Botões', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      DSPrimaryButton(text: 'Nova Transação', onPressed: () {}),
      const SizedBox(height: DSSpacing.md),
      TextButton(onPressed: () {}, style: TextButton.styleFrom(foregroundColor: DSColors.accent), child: Text('Ver Histórico Completo'.toUpperCase(), style: DSTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold))),
      const SizedBox(height: DSSpacing.xlg),
      const Text('3. Campos de Input (DSTextInput)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      const DSTextInput(label: 'Descrição da Transação', hint: 'Ex: Café, Salário, Aluguel...', icon: Icons.edit_note),
      const SizedBox(height: DSSpacing.lg),
      const DSTextInput(label: 'Valor (Apenas números)', hint: '0,00', icon: Icons.monetization_on),
      const SizedBox(height: DSSpacing.xlg),
      const Text('4. Pills de Categoria (Filtros)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      Wrap(spacing: DSSpacing.md, runSpacing: DSSpacing.sm, children: const [DSCategoryPill(text: 'Todas', isSelected: true), DSCategoryPill(text: 'Receita'), DSCategoryPill(text: 'Despesa'), DSCategoryPill(text: 'Lazer'), DSCategoryPill(text: 'Alimentação')]),
      const SizedBox(height: DSSpacing.xlg),
      const Text('5. Últimas Transações (DSTransactionTile)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      DSTransactionTile(description: 'Salário - Pagamento Mensal', category: 'Receita', amount: 4500.00, icon: Icons.work),
      Divider(color: DSColors.neutralDivider),
      DSTransactionTile(description: 'Aluguel - Pagamento Fixo', category: 'Moradia', amount: -1200.00, icon: Icons.home),
      Divider(color: DSColors.neutralDivider),
      DSTransactionTile(description: 'Supermercado Mensal', category: 'Alimentação', amount: -350.50, icon: Icons.shopping_cart),
      Divider(color: DSColors.neutralDivider),
      DSTransactionTile(description: 'Assinatura Streaming', category: 'Lazer', amount: -45.99, icon: Icons.movie),
      const SizedBox(height: DSSpacing.xlg),


      const Text('6. Lista de Dívidas (DSDebtTile)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      DSDebtTile(creditor: 'Cartão de Crédito', total: 1200.0, paid: 300.0, dueDate: DateTime.now().add(Duration(days: 5))),
      DSDebtTile(creditor: 'Empréstimo Pessoal', total: 3500.0, paid: 3500.0, dueDate: DateTime.now().subtract(Duration(days: 10))),
      const SizedBox(height: DSSpacing.xlg),

      const Text('7. Banners de Alerta (DSAlertBanner)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      DSAlertBanner(message: 'Pagamento vencendo em 2 dias para Conta de Luz.'),
      DSAlertBanner(message: 'Limite de Orçamento de Lazer atingido', color: DSColors.statusError, icon: Icons.warning),
      const SizedBox(height: DSSpacing.xlg),

      // NEW: Modal demo trigger
      const Text('8. Modal Padrão (DSModalBottomSheet)', style: DSTextStyles.h2Section),
      const SizedBox(height: DSSpacing.md),
      Row(children: [
        DSPrimaryButton(text: 'Abrir Modal', onPressed: () => DSModalBottomSheet(context: context, title: 'Exemplo de Modal', content: Column(children: [DSTextInput(label: 'Campo', hint: 'Digite...', icon: Icons.edit), const SizedBox(height: DSSpacing.md), DSPrimaryButton(text: 'Salvar', onPressed: () => Navigator.of(context).pop())]))),
      ]),
      const SizedBox(height: DSSpacing.xlg * 2),
    ]));
  }
}


void main() {
  runApp(const SystemFinanceApp());
}

class SystemFinanceApp extends StatelessWidget {
  const SystemFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Finance DS Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: DSColors.background,
        colorScheme: ColorScheme.dark(primary: DSColors.primary, secondary: DSColors.accent, background: DSColors.background, surface: DSColors.surface, error: DSColors.statusError),
      ),
      home: const DesignSystemDemoScreen(),
    );
  }
}
