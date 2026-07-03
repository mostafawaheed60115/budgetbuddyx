class AppStrings {
  AppStrings._();

  static String currentLanguage = 'en';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'BudgetBuddy',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'name': 'Name',
      'phone': 'Phone',
      'dontHaveAccount': "Don't have an account? ",
      'alreadyHaveAccount': 'Already have an account? ',
      'dashboard': 'Dashboard',
      'totalIncome': 'Total Income',
      'totalExpenses': 'Total Expenses',
      'balance': 'Balance',
      'income': 'Income',
      'addIncome': 'Add Income',
      'editIncome': 'Edit Income',
      'source': 'Source',
      'amount': 'Amount',
      'date': 'Date',
      'description': 'Description',
      'expenses': 'Expenses',
      'addExpense': 'Add Expense',
      'editExpense': 'Edit Expense',
      'category': 'Category',
      'isRecurring': 'Recurring',
      'budgets': 'Budgets',
      'addBudget': 'Add Budget',
      'editBudget': 'Edit Budget',
      'budgetLimit': 'Budget Limit',
      'month': 'Month',
      'year': 'Year',
      'savings': 'Savings',
      'addSavings': 'Add Savings Goal',
      'editSavings': 'Edit Savings Goal',
      'goalName': 'Goal Name',
      'targetAmount': 'Target Amount',
      'currentAmount': 'Current Amount',
      'targetDate': 'Target Date',
      'notifications': 'Notifications',
      'markAllAsRead': 'Mark all as read',
      'all': 'All',
      'unread': 'Unread',
      'save': 'Save',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'noData': 'No data yet',
      'error': 'Something went wrong',
      'loading': 'Loading...',
      'settings': 'Settings',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'logout': 'Logout',
    },
    'ar': {
      'appName': 'ميزانيتي',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'name': 'الاسم',
      'phone': 'الهاتف',
      'dontHaveAccount': 'ليس لديك حساب؟ ',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟ ',
      'dashboard': 'الرئيسية',
      'totalIncome': 'إجمالي الدخل',
      'totalExpenses': 'إجمالي المصروفات',
      'balance': 'الرصيد',
      'income': 'الدخل',
      'addIncome': 'إضافة دخل',
      'editIncome': 'تعديل الدخل',
      'source': 'المصدر',
      'amount': 'المبلغ',
      'date': 'التاريخ',
      'description': 'الوصف',
      'expenses': 'المصروفات',
      'addExpense': 'إضافة مصروف',
      'editExpense': 'تعديل المصروف',
      'category': 'الفئة',
      'isRecurring': 'متكرر',
      'budgets': 'الميزانيات',
      'addBudget': 'إضافة ميزانية',
      'editBudget': 'تعديل الميزانية',
      'budgetLimit': 'حد الميزانية',
      'month': 'الشهر',
      'year': 'السنة',
      'savings': 'المدخرات',
      'addSavings': 'إضافة هدف ادخار',
      'editSavings': 'تعديل هدف الادخار',
      'goalName': 'اسم الهدف',
      'targetAmount': 'المبلغ المستهدف',
      'currentAmount': 'المبلغ الحالي',
      'targetDate': 'تاريخ الاستهداف',
      'notifications': 'الإشعارات',
      'markAllAsRead': 'تحديد الكل كمقروء',
      'all': 'الكل',
      'unread': 'غير مقروء',
      'save': 'حفظ',
      'delete': 'حذف',
      'cancel': 'إلغاء',
      'noData': 'لا توجد بيانات بعد',
      'error': 'حدث خطأ ما',
      'loading': 'جاري التحميل...',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'logout': 'تسجيل الخروج',
    }
  };

  static String _tr(String key) => _localizedValues[currentLanguage]?[key] ?? key;

  static String get appName => _tr('appName');
  static String get login => _tr('login');
  static String get signup => _tr('signup');
  static String get email => _tr('email');
  static String get password => _tr('password');
  static String get confirmPassword => _tr('confirmPassword');
  static String get name => _tr('name');
  static String get phone => _tr('phone');
  static String get dontHaveAccount => _tr('dontHaveAccount');
  static String get alreadyHaveAccount => _tr('alreadyHaveAccount');
  static String get dashboard => _tr('dashboard');
  static String get totalIncome => _tr('totalIncome');
  static String get totalExpenses => _tr('totalExpenses');
  static String get balance => _tr('balance');
  static String get income => _tr('income');
  static String get addIncome => _tr('addIncome');
  static String get editIncome => _tr('editIncome');
  static String get source => _tr('source');
  static String get amount => _tr('amount');
  static String get date => _tr('date');
  static String get description => _tr('description');
  static String get expenses => _tr('expenses');
  static String get addExpense => _tr('addExpense');
  static String get editExpense => _tr('editExpense');
  static String get category => _tr('category');
  static String get isRecurring => _tr('isRecurring');
  static String get budgets => _tr('budgets');
  static String get addBudget => _tr('addBudget');
  static String get editBudget => _tr('editBudget');
  static String get budgetLimit => _tr('budgetLimit');
  static String get month => _tr('month');
  static String get year => _tr('year');
  static String get savings => _tr('savings');
  static String get addSavings => _tr('addSavings');
  static String get editSavings => _tr('editSavings');
  static String get goalName => _tr('goalName');
  static String get targetAmount => _tr('targetAmount');
  static String get currentAmount => _tr('currentAmount');
  static String get targetDate => _tr('targetDate');
  static String get notifications => _tr('notifications');
  static String get markAllAsRead => _tr('markAllAsRead');
  static String get all => _tr('all');
  static String get unread => _tr('unread');
  static String get save => _tr('save');
  static String get delete => _tr('delete');
  static String get cancel => _tr('cancel');
  static String get noData => _tr('noData');
  static String get error => _tr('error');
  static String get loading => _tr('loading');
  static String get settings => _tr('settings');
  static String get language => _tr('language');
  static String get english => _tr('english');
  static String get arabic => _tr('arabic');
  static String get logout => _tr('logout');
}
