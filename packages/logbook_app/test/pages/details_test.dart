import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook/pages/details/index.dart';
import 'package:logbook_core/logbook_core.dart';

import '../fakes/fake_system_service.dart';
import '../widget_test_app.dart';

void main() {
  late FakeSystemService systemService;

  setUp(() {
    GetIt.I.registerSingleton<SystemService>(FakeSystemService());
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('render log entry details page', (tester) async {
    tester.binding.window.platformDispatcher.textScaleFactorTestValue = 0.2;
    var logEntry = LogEntry(
      dateTime: DateTime.now(),
      title: 'Example log entry',
      directory: '/tmp/fake/example',
    );

    await tester.pumpWidget(WidgetTestApp(DetailsPage(originalLogEntry: logEntry)));

    expect(find.text('Example log entry'), findsOneWidget);
  });

  testWidgets('archive log entry', (tester) async {
    tester.binding.window.platformDispatcher.textScaleFactorTestValue = 0.2;
    systemService = GetIt.I.get<SystemService>() as FakeSystemService;
    var logEntry = LogEntry(
      dateTime: DateTime.now(),
      title: 'Example log entry',
      directory: '/tmp/fake/example',
    );

    await tester.pumpWidget(WidgetTestApp(DetailsPage(originalLogEntry: logEntry)));
    await tester.tap(find.byType(FloatingActionButton));

    expect(systemService.archivedDirectories, contains('/tmp/fake/example'));
  });
}
