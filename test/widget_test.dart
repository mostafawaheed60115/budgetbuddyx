import 'package:flutter_test/flutter_test.dart';
import 'package:budget_buddy/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetBuddyApp());
    expect(find.text('BudgetBuddy'), findsAny);
  });
}
