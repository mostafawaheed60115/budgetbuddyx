import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'services/auth_service.dart';
import 'services/income_service.dart';
import 'services/expense_service.dart';
import 'services/budget_service.dart';
import 'services/savings_service.dart';
import 'services/notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/income_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/savings_provider.dart';
import 'providers/notification_provider.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService(apiClient), apiClient),
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeProvider(IncomeService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(ExpenseService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => BudgetProvider(BudgetService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => SavingsProvider(SavingsService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(NotificationService(apiClient)),
        ),
      ],
      child: const BudgetBuddyApp(),
    ),
  );
}
