import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_app/pages/details/index.dart';
import 'package:logbook_app/pages/homepage/index.dart';
import 'package:logbook_app/pages/homepage/state.dart';
import 'package:logbook_core/logbook_core.dart';

import '../../test_bloc_observer.dart';
import '../../widget_test_app.dart';

void main() {
  setUp(() {
    GetIt.I.registerSingleton<SearchService>(_FakeSearchService());
    Bloc.observer = TestBlocObserver();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('Initial', () {
    testWidgets('page opened', (tester) async {
      await tester.pumpWidget(const WidgetTestApp(Homepage()));
      await tester.binding.delayed(const Duration(days: 5));
      expect(find.text('Logbook'), findsOneWidget);
    });
  });

  group('Showing Logs', () {
    testWidgets('search submitted', (tester) async {
      await givenShowingLogs(tester);

      await whenSearchSubmitted(tester);

      thenSearchingLogs();
    });

    testWidgets('open log details requested', (tester) async {
      givenSmallTextScale(tester);
      givenSystemService();
      givenReadService();
      await givenShowingLogs(tester);

      await whenOpenLogDetailsRequested(tester);

      thenDetailsPageOpened();
    });
  });

  group('Searching Logs', () {
    testWidgets('search finished [one or more results]', (tester) async {
      givenSearchResults();
      await givenSearchingLogs(tester);

      await whenSearchFinished(tester);

      thenShowingLogs();
    });

    testWidgets('search finished [no results]', (tester) async {
      givenNoSearchResults();
      await givenSearchingLogs(tester);

      await whenSearchFinished(tester);

      thenEmpty();
    });
  });
}

void thenDetailsPageOpened() {
  expect(find.byType(DetailsPage), findsOneWidget);
}

Future<void> whenOpenLogDetailsRequested(WidgetTester tester) async {
  await tester.tap(find.text('Hello, World!'));
  await tester.pumpAndSettle();
}

void givenReadService() {
  GetIt.I.registerSingleton<ReadService>(_FakeReadService());
}

void givenSystemService() {
  GetIt.I.registerSingleton<SystemService>(_FakeSystemService());
}

void givenSmallTextScale(WidgetTester tester) {
  tester.binding.window.platformDispatcher.textScaleFactorTestValue = 0.2;
}

void givenSearchResults() {
  final searchService = GetIt.I.get<SearchService>() as _FakeSearchService;
  searchService.searchResults.add(
    LogEntry(
      dateTime: DateTime.now(),
      title: 'Hello, World!',
      directory: '',
    ),
  );
}

void givenNoSearchResults() {
  final searchService = GetIt.I.get<SearchService>() as _FakeSearchService;
  searchService.searchResults.clear();
}

Future<void> givenSearchingLogs(WidgetTester tester) async {
  await tester.pumpWidget(const WidgetTestApp(Homepage()));
  await tester.pumpAndSettle();
  await whenSearchSubmitted(tester);
  thenSearchingLogs();
}

Future<void> givenShowingLogs(WidgetTester tester) async {
  givenSearchResults();
  await tester.pumpWidget(const WidgetTestApp(Homepage()));
  await tester.binding.delayed(const Duration(days: 1));
  await tester.pump();

  thenShowingLogs();
}

Future<void> whenSearchFinished(WidgetTester tester) async {
  await tester.pumpAndSettle();
}

Future<void> whenSearchSubmitted(
  WidgetTester tester, {
  String searchTerm = 'Foo',
}) async {
  await tester.enterText(find.byType(TextField), 'Foo');
  await tester.pump();
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  await tester.binding.delayed(const Duration(days: 5));
}

void thenShowingLogs() {
  expect(find.text('Hello, World!'), findsOneWidget);
}

void thenSearchingLogs() {
  final testBlocObserver = Bloc.observer as TestBlocObserver;
  testBlocObserver.changes.firstWhere(
    (element) => element.nextState is SearchingLogs,
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
}

void thenEmpty() {
  expect(find.text('No search results'), findsOneWidget);
}

class _FakeSearchService implements SearchService {
  final List<LogEntry> searchResults = [];

  @override
  Future<List<LogEntry>> search(
    Directory dir,
    String query, {
    bool isRegularExpression = false,
    bool negateSearch = false,
  }) async {
    await Future.delayed(const Duration(microseconds: 0));
    return searchResults;
  }

  @override
  Future<List<Note>> listNotes(LogEntry logEntry) async {
    return [];
  }
}

class _FakeSystemService implements SystemService {
  @override
  Future<void> archive(String originalDirectoryPath) {
    throw UnimplementedError();
  }

  @override
  void shutdownApp() {}
}

class _FakeReadService implements ReadService {
  @override
  Future<String> readDescriptionLogOrNoteDescriptionFile(Directory dir) async {
    return 'foo';
  }
}
