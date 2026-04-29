import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradegenz_app/features/signals/widgets/filter_tab_bar.dart';
import 'package:tradegenz_app/l10n/app_localizations.dart';

void main() {
  testWidgets('history filter tabs show outcome tabs only', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: FilterTabBar(activeFilter: 'ALL', onFilterChanged: (_) {}),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('ALL'), findsOneWidget);
    expect(find.text('WIN'), findsOneWidget);
    expect(find.text('LOSS'), findsOneWidget);
    expect(find.text('SYSTEM'), findsNothing);
  });
}
