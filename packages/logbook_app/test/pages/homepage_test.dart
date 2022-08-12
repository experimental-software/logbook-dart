import 'package:flutter_test/flutter_test.dart';
import 'package:logbook/pages/homepage/index.dart';

import '../widget_test_app.dart';

void main() {
  testWidgets('render homepage', (tester) async {
    await tester.pumpWidget(const WidgetTestApp(Homepage()));

    expect(find.text('Logbook'), findsOneWidget);
  });
}