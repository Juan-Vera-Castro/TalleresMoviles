import 'package:flutter_test/flutter_test.dart';

import 'package:taller1/main.dart';

void main() {
  testWidgets('La app abre en la pantalla principal', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dashboard Principal'), findsOneWidget);
  });
}
