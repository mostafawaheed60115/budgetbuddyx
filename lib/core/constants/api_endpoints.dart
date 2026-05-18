class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://budget-buddy-production.up.railway.app';

  // Auth
  static const String signup = '/signup';
  static const String login = '/login';

  // Income
  static const String income = '/income';
  static String incomeById(String id) => '/income/$id';

  // Expenses
  static const String expenses = '/expenses';
  static String expenseById(String id) => '/expenses/$id';

  // Budgets
  static const String budgets = '/budgets';
  static String budgetById(String id) => '/budgets/$id';

  // Savings
  static const String savings = '/savings';
  static String savingsById(String id) => '/savings/$id';

  // Notifications
  static const String notifications = '/notifications/';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';
}
