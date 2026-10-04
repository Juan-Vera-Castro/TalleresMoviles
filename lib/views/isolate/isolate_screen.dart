import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../isolates/tarea_pesada.dart';
import '../../widgets/base_view.dart';

/// !IsolateScreen
/// Ejecuta una tarea pesada (CPU-bound) en un Isolate con Isolate.spawn
/// y recibe el resultado por mensajes (ReceivePort / SendPort).
/// La animación de carga demuestra que la UI no se congela.
class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => IsolateScreenState();
}

class IsolateScreenState extends State<IsolateScreen> {
  /// Cantidad de números a sumar (tarda algunos segundos)
  static const int _limite = 1000000000;

  Isolate? _isolate;
  ReceivePort? _receivePort;

  bool _calculando = false;
  String _resultado = 'Aún no se ha ejecutado la tarea';

  /// !ejecutarEnIsolate
  Future<void> ejecutarEnIsolate() async {
    setState(() {
      _calculando = true;
      _resultado = 'Calculando en un Isolate…';
    });

    // *Puerto por donde el Isolate enviará el resultado
    final receivePort = ReceivePort();
    _receivePort = receivePort;

    try {
      debugPrint('🧵 Lanzando Isolate.spawn...');
      _isolate = await Isolate.spawn(tareaPesadaIsolate, (
        receivePort.sendPort,
        _limite,
      ));

      // Espera el primer mensaje que envíe el Isolate
      final mensaje = await receivePort.first as Map<String, dynamic>;
      debugPrint('📩 Mensaje recibido del Isolate: $mensaje');

      if (!mounted) return;
      setState(() {
        _resultado =
            'Suma de 1 a $_limite = ${mensaje['resultado']}\n'
            '(${mensaje['milisegundos']} ms en el Isolate)';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _resultado = 'Error al ejecutar el Isolate: $e');
    } finally {
      _liberarIsolate();
      if (mounted) setState(() => _calculando = false);
    }
  }

  /// !ejecutarSinIsolate
  /// Misma tarea en el hilo principal, para comparar: la UI se congela.
  Future<void> ejecutarSinIsolate() async {
    setState(() {
      _calculando = true;
      _resultado = 'Calculando en el hilo principal…';
    });

    // Se espera un frame para que se alcance a pintar el mensaje
    await Future.delayed(const Duration(milliseconds: 100));

    final cronometro = Stopwatch()..start();
    final resultado = sumaPesada(_limite); // !Bloquea la UI mientras corre
    cronometro.stop();

    if (!mounted) return;
    setState(() {
      _calculando = false;
      _resultado =
          'Suma de 1 a $_limite = $resultado\n'
          '(${cronometro.elapsedMilliseconds} ms en el hilo principal, '
          'la UI estuvo congelada)';
    });
  }

  /// Cierra el puerto y termina el Isolate
  void _liberarIsolate() {
    _receivePort?.close();
    _receivePort = null;
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  /// !dispose: si se sale de la vista durante el cálculo, se termina el Isolate
  @override
  void dispose() {
    _liberarIsolate();
    debugPrint('🔴 dispose() -> Isolate y puerto liberados');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BaseView(
      title: 'Isolate para tarea pesada',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Suma los números de 1 a mil millones con un ciclo. '
              'Con Isolate la animación sigue girando; sin Isolate se congela.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // *Isolate.spawn no está disponible en Flutter Web
            if (kIsWeb)
              Card(
                color: colorScheme.errorContainer,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Isolate.spawn no funciona en web. '
                    'Ejecuta la app en Android o Windows.',
                  ),
                ),
              ),

            ElevatedButton.icon(
              onPressed: (_calculando || kIsWeb) ? null : ejecutarEnIsolate,
              icon: const Icon(Icons.memory),
              label: const Text('Ejecutar en Isolate'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _calculando ? null : ejecutarSinIsolate,
              icon: const Icon(Icons.warning_amber),
              label: const Text('Ejecutar sin Isolate (comparar)'),
            ),
            const SizedBox(height: 32),

            // Indicador animado: si gira, la UI no está bloqueada
            Center(
              child: SizedBox(
                width: 64,
                height: 64,
                child: _calculando
                    ? const CircularProgressIndicator(strokeWidth: 6)
                    : Icon(
                        Icons.check_circle,
                        size: 64,
                        color: colorScheme.primary,
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _resultado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
