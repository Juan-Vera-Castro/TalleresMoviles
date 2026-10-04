import 'package:flutter/foundation.dart';

/// !DatosService
/// Servicio simulado que "consulta" datos a un servidor.
/// Usa Future.delayed para imitar la espera de una petición real (2–3 s)
/// sin bloquear la interfaz.
class DatosService {
  /// Tiempo que tarda la "consulta" simulada
  static const Duration demora = Duration(milliseconds: 2500);

  /// !consultarDatos
  /// Retorna un Future: el resultado estará disponible más adelante.
  /// *Si [simularError] es true, la consulta termina lanzando una excepción.
  Future<List<String>> consultarDatos({bool simularError = false}) async {
    debugPrint('2️⃣ DURANTE -> El servicio empezó la consulta (esperando...)');

    // *await suspende esta función, pero NO congela la UI
    await Future.delayed(demora);

    if (simularError) {
      debugPrint('❌ DURANTE -> El servidor respondió con error');
      throw Exception('No se pudo conectar con el servidor');
    }

    debugPrint('4️⃣ DURANTE -> El servicio recibió la respuesta');
    return const [
      'Programación Móvil',
      'Bases de Datos',
      'Ingeniería de Software',
      'Redes de Computadores',
    ];
  }
}
