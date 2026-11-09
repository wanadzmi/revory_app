import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revory/features/garage/controllers/garage_controller.dart';
import 'package:revory/features/home/pages/home_page.dart';
import 'package:revory/features/maintenance/controllers/history_controller.dart';
import 'package:revory/features/maintenance/pages/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Home owns vehicle selection and updates its summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: HomePage())),
      ),
    );
    await tester.tap(find.text('Mazda CX-5'));
    await tester.pumpAndSettle();
    expect(find.text('Choose vehicle'), findsOneWidget);
    await tester.tap(find.text('Honda City'));
    await tester.pumpAndSettle();
    expect(find.text('Choose vehicle'), findsNothing);
    expect(find.text('Honda City'), findsOneWidget);
    expect(find.text('Mazda CX-5'), findsNothing);
  });

  testWidgets('History opens and saves its maintenance form', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: HistoryPage())),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HistoryPage)),
    );
    final vehicleId = container.read(garageControllerProvider).vehicle.id;
    expect(find.text('3 records saved for VBT 4821'), findsOneWidget);
    await tester.tap(find.byTooltip('Add maintenance'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Service or part'),
      'Air filter',
    );
    await tester.pump();
    await tester.tap(find.text('Save maintenance'));
    await tester.pumpAndSettle();
    final saved = container.read(historyControllerProvider).first;
    expect(saved.title, 'Air filter');
    expect(saved.vehicleId, vehicleId);
    expect(find.text('Air filter'), findsOneWidget);
    expect(find.text('Maintenance saved to your history.'), findsOneWidget);
    expect(find.text('4 records saved for VBT 4821'), findsOneWidget);
    await container.read(garageControllerProvider.notifier).selectVehicle(1);
    await tester.pump();
    expect(find.text('0 records saved for WXY 1937'), findsOneWidget);
  });
}
