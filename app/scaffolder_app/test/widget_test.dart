import 'package:flutter_test/flutter_test.dart';

import 'package:scaffolder_app/main.dart';

void main() {
  testWidgets('shows the scaffolder builder screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ScaffolderApp());

    expect(find.text('Flutter AI Scaffolder'), findsWidgets);
    expect(find.text('Project Builder'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
