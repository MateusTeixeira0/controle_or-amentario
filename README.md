# controle_orcamentario

## 🚀 PRISMATIK FINANCE APP
Aplicativo móvel de Gestão de Finanças Pessoais desenvolvido em Flutter. 
Este repositório demonstra a aplicação prática de um Design System robusto na construção de uma aplicação funcional e escalável.

## 📌 Objetivo e Contexto
Este projeto é a evolução da fase inicial de Design System Sample. 
O foco agora é demonstrar a transformação dos componentes visuais em telas completas de alta fidelidade, servindo como um estudo prático de:

 - Reutilização e modularidade de componentes UI.

 - Organização de código em camadas (Screens, System Design).

 - Estudo de arquitetura e boas práticas para projetos Flutter.

   
## 🎯 Propósito do Produto (Prismatik Finance)
O aplicativo visa ser uma ferramenta clara e eficiente para o controle financeiro, oferecendo aos usuários a capacidade de:

 - Acompanhar o Balanço Total e o progresso do Orçamento na Dashboard.

 - Gerenciar Orçamentos por categorias, visualizando o gasto vs. o alocado.

 - Rastrear Metas de Economia com indicadores visuais de progresso e prazo.

 - Controlar Dívidas e marcar pagamentos.

 - Gerenciar o Perfil de usuário.

## 🏛 Estrutura de Código e Arquitetura (Fase Inicial)
A estrutura atual está otimizada para o desenvolvimento rápido da interface, utilizando o
Gerenciamento de Estado Local do Flutter.

| Camada         | Função e Status | Exemplos no Código  |
|----------------|-----------------|---------------------|
| Design System  | Foundation para toda a aplicação (Cores, Tipografia, Componentes).  | DSColors, DSTextStyles, DSModalBottomSheet. |
| Screens (View) | Responsável pela renderização da interface e composição de componentes.  | DashboardScreen, GoalsScreen. |
| Estado Local (Mock Data)  | Gerencia o estado da UI e contém Dados Mock para simular o comportamento de um backend.  |_debts (em debts_screen.dart), _goals (em goals_screen.dart), mockBudgets (em budget_screen.dart). |
| Autenticação   | Login simulado para transição de tela. | Future.delayed(const Duration(seconds: 1)); na função handleLogin. | 

##🚦 Simulação de API e Dados Mock
Para permitir o desenvolvimento contínuo da interface sem depender de um backend real, o projeto utiliza dados e lógica de simulação:

**1. Dados Mock**
Os dados exibidos em todas as telas são dados mock (simulados), armazenados localmente nas classes State dos Widgets.

Exemplos:

 - totalBalance = 7890.50 (em dashboard_screen.dart).

 - List<Map<String, dynamic>> _debts (em debts_screen.dart).

 - List<BudgetData> mockBudgets (em budget_screen.dart).

## 2. Simulação de Latência (Login)
A funcionalidade de Login simula o tempo de resposta de um servidor através do uso do Future.delayed:

Dart
 `await Future.delayed(const Duration(seconds: 1)); // simula login`
 
Esta linha, presente na função handleLogin do login_screen.dart, garante que a animação 
de carregamento seja executada, imitando a latência de uma requisição de rede (API) real, antes de navegar para a Dashboard.





















