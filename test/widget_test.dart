import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taller1/main.dart';

void main() {
  testWidgets('Muestra el título inicial y el nombre del estudiante', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Hola, Flutter'),
      ),
      findsOneWidget,
    );
    expect(find.text('Juan Esteban Vera Castro'), findsOneWidget);
  });

  testWidgets('El botón alterna el título y muestra el SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final boton = find.widgetWithText(ElevatedButton, 'Cambiar título');

    await tester.tap(boton);
    await tester.pump();

    expect(find.text('¡Título cambiado!'), findsOneWidget);
    expect(find.text('Hola, Flutter'), findsNothing);
    expect(find.text('Título actualizado'), findsOneWidget);

    await tester.tap(boton);
    await tester.pump();

    expect(find.text('Hola, Flutter'), findsOneWidget);
    expect(find.text('¡Título cambiado!'), findsNothing);
  });
}
