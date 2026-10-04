import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taller1/isolates/tarea_pesada.dart';
import 'package:taller1/main.dart';
import 'package:taller1/views/asincronia/asincronia_screen.dart';
import 'package:taller1/views/cronometro/cronometro_screen.dart';

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

  testWidgets('Cronómetro: iniciar, pausar, reanudar y reiniciar', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CronometroScreen()));
    expect(find.text('00:00.0'), findsOneWidget);

    await tester.tap(find.text('Iniciar'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01.0'), findsOneWidget);

    // En pausa el tiempo no avanza
    await tester.tap(find.text('Pausar'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:01.0'), findsOneWidget);

    await tester.tap(find.text('Reanudar'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('00:01.5'), findsOneWidget);

    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(find.text('00:00.0'), findsOneWidget);

    // Al salir de la vista con el timer corriendo, dispose() lo cancela
    // (si no, la prueba falla con "A Timer is still pending")
    await tester.tap(find.text('Iniciar'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(const SizedBox());
  });

  test('sumaPesada calcula la suma de 1 a n', () {
    expect(sumaPesada(10), 55);
    expect(sumaPesada(1000000), 500000500000);
  });
}
