import 'package:flutter/material.dart';

import '../../services/datos_service.dart';
import '../../widgets/base_view.dart';

/// Estados posibles de la consulta
enum EstadoConsulta { inicial, cargando, exito, error }

/// !AsincroniaScreen
/// Demuestra el uso de Future, async y await:
/// se llama a un servicio simulado y se muestran los estados
/// Cargando… / Éxito / Error mientras la UI sigue respondiendo.
class AsincroniaScreen extends StatefulWidget {
  const AsincroniaScreen({super.key});

  @override
  State<AsincroniaScreen> createState() => AsincroniaScreenState();
}

class AsincroniaScreenState extends State<AsincroniaScreen> {
  final DatosService _servicio = DatosService();

  EstadoConsulta _estado = EstadoConsulta.inicial;
  List<String> _datos = [];
  String _mensajeError = '';

  /// !consultar
  /// *async permite usar await dentro del método
  Future<void> consultar({bool simularError = false}) async {
    setState(() => _estado = EstadoConsulta.cargando);

    debugPrint('1️⃣ ANTES -> Se llama al servicio');

    // Se obtiene el Future sin esperarlo todavía
    final consulta = _servicio.consultarDatos(simularError: simularError);

    // Esta línea se imprime ANTES de que llegue la respuesta:
    // demuestra que el hilo principal (la UI) no se bloquea
    debugPrint('3️⃣ MIENTRAS -> La UI sigue libre, el Future está pendiente');

    try {
      final datos = await consulta;

      // *Si el usuario salió de la pantalla durante la espera, no se actualiza
      if (!mounted) return;
      setState(() {
        _datos = datos;
        _estado = EstadoConsulta.exito;
      });
      debugPrint('5️⃣ DESPUÉS -> Datos recibidos: ${datos.length} elementos');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = e.toString().replaceFirst('Exception: ', '');
        _estado = EstadoConsulta.error;
      });
      debugPrint('5️⃣ DESPUÉS -> Se capturó el error: $_mensajeError');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cargando = _estado == EstadoConsulta.cargando;

    return BaseView(
      title: 'Future / async / await',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'El servicio tarda 2,5 s en responder. Mientras tanto la '
              'pantalla sigue respondiendo. Revisa la consola para ver el '
              'orden de ejecución.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: cargando ? null : () => consultar(),
              icon: const Icon(Icons.cloud_download),
              label: const Text('Consultar datos'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: cargando ? null : () => consultar(simularError: true),
              icon: const Icon(Icons.error_outline),
              label: const Text('Simular error'),
            ),
            const SizedBox(height: 24),
            _construirEstado(context),
          ],
        ),
      ),
    );
  }

  /// Muestra un widget distinto según el estado actual
  Widget _construirEstado(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (_estado) {
      case EstadoConsulta.inicial:
        return const Text(
          'Presiona un botón para iniciar la consulta',
          textAlign: TextAlign.center,
        );
      case EstadoConsulta.cargando:
        return const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Cargando…', style: TextStyle(fontSize: 18)),
          ],
        );
      case EstadoConsulta.exito:
        return Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: colorScheme.primary),
                title: const Text(
                  'Éxito',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              for (final dato in _datos)
                ListTile(leading: const Icon(Icons.book), title: Text(dato)),
            ],
          ),
        );
      case EstadoConsulta.error:
        return Card(
          color: colorScheme.errorContainer,
          child: ListTile(
            leading: Icon(Icons.error, color: colorScheme.error),
            title: const Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_mensajeError),
          ),
        );
    }
  }
}
