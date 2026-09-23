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
      appBar: AppBar(title: Text(_tituloAppBar)),
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
                  const SizedBox(height: 24),

                  // ===== ListView con 4 elementos =====
                  _Seccion(
                    titulo: 'Menú',
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _opcionesMenu.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, index) {
                          final opcion = _opcionesMenu[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.secondaryContainer,
                              child: Icon(
                                opcion.icono,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                            title: Text(opcion.texto),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== Stack: texto sobre imagen =====
                  _Seccion(
                    titulo: 'Destacado',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 180,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _ImagenNoDisponible(),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black87],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Text(
                                'Texto sobre la imagen (Stack)',
                                style: textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ===== GridView con 4 celdas =====
                  _Seccion(
                    titulo: 'Accesos rápidos',
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: const [
                        _CeldaGrid(icono: Icons.home, texto: 'Inicio'),
                        _CeldaGrid(icono: Icons.star, texto: 'Favoritos'),
                        _CeldaGrid(icono: Icons.person, texto: 'Perfil'),
                        _CeldaGrid(icono: Icons.settings, texto: 'Ajustes'),
                      ],
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

// ===== Clase auxiliar para las celdas del GridView =====
class _CeldaGrid extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _CeldaGrid({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: colorScheme.primary, size: 32),
          const SizedBox(height: 8),
          Text(
            texto,
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
