import 'dart:isolate';

/// !sumaPesada
/// Función CPU-bound: suma todos los números de 1 a [limite]
/// con un ciclo (sin usar la fórmula) para que tarde varios segundos.
int sumaPesada(int limite) {
  var suma = 0;
  for (var i = 1; i <= limite; i++) {
    suma += i;
  }
  return suma;
}

/// !tareaPesadaIsolate
/// Punto de entrada del Isolate.
/// *Debe ser una función top-level (o static) para poder usarse en Isolate.spawn.
///
/// Recibe un mensaje con:
/// - el SendPort por donde devolver el resultado
/// - el límite de la suma
void tareaPesadaIsolate((SendPort, int) mensaje) {
  final (sendPort, limite) = mensaje;

  final cronometro = Stopwatch()..start();
  final resultado = sumaPesada(limite);
  cronometro.stop();

  // Se envía el resultado de vuelta al hilo principal por mensaje
  sendPort.send({
    'resultado': resultado,
    'milisegundos': cronometro.elapsedMilliseconds,
  });
}
