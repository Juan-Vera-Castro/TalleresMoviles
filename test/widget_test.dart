import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taller1/main.dart';
import 'package:taller1/views/asincronia/asincronia_screen.dart';

void main() {
  testWidgets('La app abre en la pantalla principal', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dashboard Principal'), findsOneWidget);
  });

  group('Future / async / await', () {
    testWidgets('Muestra Cargando… y luego Éxito', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AsincroniaScreen()));

      await tester.tap(find.text('Consultar datos'));
      await tester.pump();
      expect(find.text('Cargando…'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Éxito'), findsOneWidget);
      expect(find.text('Programación Móvil'), findsOneWidget);
    });

    testWidgets('Muestra Error cuando el servicio falla', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AsincroniaScreen()));

      await tester.tap(find.text('Simular error'));
      await tester.pump();
      expect(find.text('Cargando…'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
    });
  });
}
