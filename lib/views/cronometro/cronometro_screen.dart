import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/base_view.dart';

/// Estados del cronómetro
enum EstadoCronometro { detenido, corriendo, pausado }

/// !CronometroScreen
/// Cronómetro implementado con Timer.periodic.
/// Se actualiza cada 100 ms y el timer se cancela al pausar,
/// al reiniciar y al salir de la vista (dispose).
class CronometroScreen extends StatefulWidget {
  const CronometroScreen({super.key});

  @override
  State<CronometroScreen> createState() => CronometroScreenState();
}

class CronometroScreenState extends State<CronometroScreen> {
  static const Duration _intervalo = Duration(milliseconds: 100);

  /// *Se guarda la referencia al Timer para poder cancelarlo
  Timer? _timer;

  /// Tiempo transcurrido en décimas de segundo
  int _decimas = 0;
  EstadoCronometro _estado = EstadoCronometro.detenido;

  void _iniciarTimer() {
    _timer?.cancel(); // Evita que existan dos timers a la vez
    _timer = Timer.periodic(_intervalo, (_) {
      setState(() => _decimas++);
    });
  }

  void iniciar() {
    debugPrint('▶️ Cronómetro iniciado');
    _iniciarTimer();
    setState(() => _estado = EstadoCronometro.corriendo);
  }

  void pausar() {
    _timer?.cancel(); // !Se cancela el timer: deja de consumir recursos
    debugPrint('⏸️ Cronómetro pausado en ${_formatear(_decimas)}');
    setState(() => _estado = EstadoCronometro.pausado);
  }

  void reanudar() {
    debugPrint('⏯️ Cronómetro reanudado');
    _iniciarTimer(); // Continúa desde el tiempo guardado
    setState(() => _estado = EstadoCronometro.corriendo);
  }

  void reiniciar() {
    _timer?.cancel();
    debugPrint('🔄 Cronómetro reiniciado');
    setState(() {
      _decimas = 0;
      _estado = EstadoCronometro.detenido;
    });
  }

  /// !dispose: limpieza de recursos al salir de la vista
  @override
  void dispose() {
    _timer?.cancel();
    debugPrint('🔴 dispose() -> Timer cancelado al salir de la vista');
    super.dispose();
  }

  /// Convierte décimas a formato mm:ss.d
  String _formatear(int decimas) {
    final minutos = (decimas ~/ 600).toString().padLeft(2, '0');
    final segundos = ((decimas ~/ 10) % 60).toString().padLeft(2, '0');
    final decima = decimas % 10;
    return '$minutos:$segundos.$decima';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BaseView(
      title: 'Cronómetro con Timer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== Marcador =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _formatear(_decimas),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                  // *Dígitos de ancho fijo para que el marcador no "salte"
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('Estado: ${_estado.name}'),
            const SizedBox(height: 24),

            // ===== Botones =====
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _estado == EstadoCronometro.detenido
                      ? iniciar
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                ),
                ElevatedButton.icon(
                  onPressed: _estado == EstadoCronometro.corriendo
                      ? pausar
                      : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pausar'),
                ),
                ElevatedButton.icon(
                  onPressed: _estado == EstadoCronometro.pausado
                      ? reanudar
                      : null,
                  icon: const Icon(Icons.play_circle),
                  label: const Text('Reanudar'),
                ),
                OutlinedButton.icon(
                  onPressed: _estado == EstadoCronometro.detenido
                      ? null
                      : reiniciar,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reiniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
