import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logbook_app/pages/homepage/index.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:get_it/get_it.dart';

import '../../widget_test_app.dart';

void main() {
  late _FakeSearchService searchService;

  setUp(() {
    GetIt.I.registerSingleton<SearchService>(_FakeSearchService());
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('Initial', () {
    testWidgets('render homepage', (tester) async {
      await tester.pumpWidget(const WidgetTestApp(Homepage()));

      expect(find.text('Logbook'), findsOneWidget);
    });
  });

  group('Showing Logs', () {
    testWidgets('search submitted', (tester) async {
      // ignore: prefer_function_declarations_over_variables
      var givenStateShowingLogs = (WidgetTester tester) async {
        searchService = GetIt.I.get<SearchService>() as _FakeSearchService;
        searchService.searchResults.add(
          LogEntry(
            dateTime: DateTime.now(),
            title: 'Hello, World!',
            directory: '',
          ),
        );
        await tester.pumpWidget(const WidgetTestApp(Homepage()));
        await tester.pumpAndSettle();
        expect(find.text('Hello, World!'), findsOneWidget);
      };

      await givenStateShowingLogs(tester);

      // When search submitted
      // ignore: prefer_function_declarations_over_variables
      var whenSearchSubmitted = (WidgetTester tester,
          {String searchTerm = 'Foo',}) async {
        await tester.enterText(find.byType(TextField), 'Foo');
        await tester.pump();
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
      };

      await whenSearchSubmitted(tester);


      // Then state "Searching Logs"
      // ignore: prefer_function_declarations_over_variables
      final thenSearchingLogs = () {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      };
      thenSearchingLogs();
      
    });
  });

  // group('Showing Logs', () {
  //   testWidgets('search finished [one or more results]', (tester) async {
  //     tester.binding.window.platformDispatcher.textScaleFactorTestValue = 0.2;
  //
  //     var widget = Text('Hello, Widget!');
  //     await tester.pumpWidget(WidgetTestApp(widget));
  //
  //     expect(find.byType(Text), findsWidgets);
  //   });
  // });

  // group('Empty', () {
  //   testWidgets('search finished [no results]', (tester) async {
  //     tester.binding.window.platformDispatcher.textScaleFactorTestValue = 0.2;
  //
  //     var widget = Text('Hello, Widget!');
  //     await tester.pumpWidget(WidgetTestApp(widget));
  //
  //     expect(find.byType(Text), findsWidgets);
  //   });
  // });
}

class _FakeSearchService implements SearchService {
  final List<LogEntry> searchResults = [];

  @override
  Future<List<LogEntry>> search(Directory dir,
      String query, {
        bool isRegularExpression = false,
        bool negateSearch = false,
      }) async {
    return searchResults;
  }

  @override
  Future<List<Note>> listNotes(LogEntry logEntry) async {
    return [];
  }
}
