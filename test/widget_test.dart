import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddlyiq/main.dart';

void main() {
  testWidgets('App launches with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: OddlyIQApp()));

    expect(find.text('ODDLYIQ'), findsOneWidget);
    expect(find.text('Find The Odd One'), findsOneWidget);
  });
}
