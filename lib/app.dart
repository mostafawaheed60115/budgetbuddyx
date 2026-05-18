import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/income/income_list_screen.dart';
import 'screens/income/income_form_screen.dart';
import 'screens/expenses/expense_list_screen.dart';
import 'screens/expenses/expense_form_screen.dart';
import 'screens/budgets/budget_list_screen.dart';
import 'screens/budgets/budget_form_screen.dart';
import 'screens/savings/savings_list_screen.dart';
import 'screens/savings/savings_form_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/widgets/bottom_nav_bar.dart';

class BudgetBuddyApp extends StatelessWidget {
  const BudgetBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeShell(),
        '/income/form': (_) => const IncomeFormScreen(),
        '/expense/form': (_) => const ExpenseFormScreen(),
        '/budget/form': (_) => const BudgetFormScreen(),
        '/savings/form': (_) => const SavingsFormScreen(),
        '/notifications': (_) => const NotificationsScreen(),
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    IncomeListScreen(),
    ExpenseListScreen(),
    BudgetListScreen(),
    SavingsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
