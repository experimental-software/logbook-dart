import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_app/pages/details/index.dart';
import 'package:logbook_core/logbook_core.dart';

import '../fake_services.dart';
import '../widget_test_app.dart';

void main() {
  setUp(() {
    GetIt.I.registerSingleton<SystemService>(FakeSystemService());
    GetIt.I.registerSingleton<ReadService>(FakeReadService());
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

    await tester
        .pumpWidget(WidgetTestApp(DetailsPage(originalLogEntry: logEntry)));
    await tester.pumpAndSettle();

    expect(find.text('Example log entry'), findsOneWidget);
  });
}
