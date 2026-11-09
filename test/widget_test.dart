import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revory/app.dart';

void main() {
  testWidgets('shows the Revory garage home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RevoryApp()));

    expect(find.text("Driver's garage"), findsOneWidget);
    expect(find.text('Mazda CX-5'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
