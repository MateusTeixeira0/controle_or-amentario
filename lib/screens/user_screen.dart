import 'package:flutter/material.dart';
import 'design_system_info.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool isEditing = false;

  final TextEditingController nameController = TextEditingController(text: "Usuário Teste");
  final TextEditingController emailController = TextEditingController(text: "usuario@email.com");
  final TextEditingController statusController = TextEditingController(text: "Ativo");

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: AppBar(
        backgroundColor: DSColors.surface,
        elevation: 0,
        title: const Text("Meu Perfil", style: DSTextStyles.h2Section),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 28, color: Colors.white),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DSSpacing.xlg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // FOTO DO USUÁRIO
              CircleAvatar(
                radius: 50,
                backgroundColor: DSColors.primary,
                child: const Icon(Icons.person, size: 60, color: Colors.black),
              ),

              const SizedBox(height: DSSpacing.xlg),

              // CARD DE INFORMAÇÕES
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: DSColors.surface,
                  borderRadius: DSBorders.radiusLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: "Nome"),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: statusController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: "Status"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: DSSpacing.xlg),

             
              // BOTÃO SALVAR QUANDO EDITANDO
              if (isEditing)
                ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1).animate(
                    CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DSColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: DSBorders.radiusMedium),
                      ),
                      onPressed: () async {
                        // animação ao clicar
                        _animationController.reverse();

                        // simula carregamento
                        await Future.delayed(const Duration(milliseconds: 600));

                        setState(() {
                          isEditing = false;
                        });

                        // volta animação
                        _animationController.forward();

                        // snackbar de confirmação
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Alterações salvas com sucesso!"),
                            backgroundColor: DSColors.primary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        "Salvar Alterações",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),


              // BOTÃO LOGOUT
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: DSBorders.radiusMedium),
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                child: const Text("Sair da conta", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
