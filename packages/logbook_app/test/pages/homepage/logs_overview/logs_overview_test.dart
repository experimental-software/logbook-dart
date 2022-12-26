import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_app/pages/details/index.dart';
import 'package:logbook_app/pages/homepage/index.dart';
import 'package:logbook_core/logbook_core.dart';

import '../../../widget_test_app.dart';

void main() {
  // setUp(() {
  //   GetIt.I.registerSingleton<SearchService>(_FakeSearchService());
  // });
  //
  // tearDown(() async {
  //   await GetIt.I.reset();
  // });




  // group('Initial', () {
  //   testWidgets('page opened', (tester) async {
  //     await tester.pumpWidget(const WidgetTestApp(Homepage()));
  //
  //     expect(find.text('Logbook'), findsOneWidget);
  //   });
  // });
  //
  // group('Showing Logs', () {
  //   testWidgets('search submitted', (tester) async {
  //     await givenShowingLogs(tester);
  //
  //     await whenSearchSubmitted(tester);
  //
  //     thenSearchingLogs();
  //   });
  //
  //   testWidgets('open log details requested', (tester) async {
  //     givenSmallTextScale(tester);
  //     givenSystemService();
  //     givenReadService();
  //     await givenShowingLogs(tester);
  //
  //     await whenOpenLogDetailsRequested(tester);
  //
  //     thenDetailsPageOpened();
  //   });
  // });

  // group('Searching Logs', () {
  //   testWidgets('search finished [one or more results]', (tester) async {
  //     givenSearchResults();
  //     await givenSearchingLogs(tester);
  //
  //     await whenSearchFinished(tester);
  //
  //     thenShowingLogs();
  //   });
  //
  //   testWidgets('search finished [no results]', (tester) async {
  //     givenNoSearchResults();
  //     await givenSearchingLogs(tester);
  //
  //     await whenSearchFinished(tester);
  //
  //     thenEmpty();
  //   });
  // });
}

