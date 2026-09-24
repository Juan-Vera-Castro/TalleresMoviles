import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Color institucional (verde UCEVA) usado como base de todo el tema
const Color _colorUceva = Color(0xFF00843D);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: _colorUceva);

    return MaterialApp(
      title: 'Taller 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _tituloAppBar = 'Hola, Flutter';

  void _cambiarTitulo() {
    setState(() {
      _tituloAppBar = (_tituloAppBar == 'Hola, Flutter')
          ? '¡Título cambiado!'
          : 'Hola, Flutter';
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Título actualizado')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Al tener un drawer, el AppBar muestra automáticamente el botón de 3 líneas
      appBar: AppBar(title: Text(_tituloAppBar)),
      drawer: const _MenuLateral(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ===== Encabezado: nombre del estudiante (Container) =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      border: Border.all(color: colorScheme.primary, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: colorScheme.primary,
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Juan Esteban Vera Castro',
                          textAlign: TextAlign.center,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Código 230232042 · Taller 1',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== Imágenes en un Row =====
                  _Seccion(
                    titulo: 'Imágenes',
                    child: Row(
                      children: [
                        Expanded(
                          child: _ImagenConEtiqueta(
                            etiqueta: 'Image.network',
                            imagen: Image.network(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _ImagenNoDisponible(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ImagenConEtiqueta(
                            etiqueta: 'Image.asset',
                            fondo: Colors.white,
                            imagen: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/IMAGOTIPO-UCEVA.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== Botón obligatorio con setState =====
                  Center(
                    child: ElevatedButton(
                      onPressed: _cambiarTitulo,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz),
                          SizedBox(width: 8),
                          Text('Cambiar título'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Datos del ListView =====
class _OpcionMenu {
  final IconData icono;
  final String texto;

  const _OpcionMenu(this.icono, this.texto);
}

const List<_OpcionMenu> _opcionesMenu = [
  _OpcionMenu(Icons.map, 'Mapa'),
  _OpcionMenu(Icons.photo, 'Álbum'),
  _OpcionMenu(Icons.phone, 'Contactos'),
  _OpcionMenu(Icons.settings, 'Ajustes'),
];

// ===== Menú desplegable (Drawer) con el ListView de 4 elementos =====
class _MenuLateral extends StatelessWidget {
  const _MenuLateral();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menú',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          for (final opcion in _opcionesMenu)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.secondaryContainer,
                child: Icon(
                  opcion.icono,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              title: Text(opcion.texto),
              // Cierra el menú al elegir una opción
              onTap: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}

// ===== Sección con título, para mantener el mismo estilo en toda la página =====
class _Seccion extends StatelessWidget {
  final String titulo;
  final Widget child;

  const _Seccion({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// ===== Imagen cuadrada con etiqueta debajo =====
class _ImagenConEtiqueta extends StatelessWidget {
  final Widget imagen;
  final String etiqueta;
  final Color? fondo;

  const _ImagenConEtiqueta({
    required this.imagen,
    required this.etiqueta,
    this.fondo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: fondo ?? colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: imagen,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          etiqueta,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ===== Imagen de respaldo cuando Image.network no puede cargar =====
class _ImagenNoDisponible extends StatelessWidget {
  const _ImagenNoDisponible();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
    );
  }
}
