import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logbook/pages/homepage/index.dart';
import 'package:logbook_core/logbook_core.dart';

import '../widget_test_app.dart';

void main() {
  testWidgets('render homepage', (tester) async {
    await tester.pumpWidget(const WidgetTestApp(Homepage()));

    expect(find.text('Logbook'), findsOneWidget);
  });

  testWidgets('show all log entries after opening the app', (tester) async {
    System.baseDir = Directory('./test/test_data/single_log');
    await tester.pumpWidget(const WidgetTestApp(Homepage()));

    //await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(hours: 60));
    await tester.pumpAndSettle();
    //
    expect(find.text('Example log entry'), findsOneWidget);
  });
}