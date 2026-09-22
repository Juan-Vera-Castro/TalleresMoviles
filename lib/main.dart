import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        .showSnackBar(const SnackBar(content: Text('Título actualizado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Juan Esteban Vera Castro',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Row con las dos imágenes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/IMAGOTIPO-UCEVA.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botón obligatorio con setState
              ElevatedButton(
                onPressed: _cambiarTitulo,
                child: const Text('Cambiar título'),
              ),
              const SizedBox(height: 20),

              // Container decorado
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Este es un Container con borde, color y márgenes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // ListView con 4 ListTile
              SizedBox(
                height: 220,
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.map, color: Colors.blue),
                      title: Text('Mapa'),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo, color: Colors.green),
                      title: Text('Álbum'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.orange),
                      title: Text('Contactos'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text('Ajustes'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ===== WIDGET EXTRA #3: Stack =====
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Texto sobre la imagen (Stack)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ===== WIDGET EXTRA #4: GridView =====
              SizedBox(
                height: 240,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    _CeldaGrid(
                      color: Colors.teal,
                      icono: Icons.home,
                      texto: 'Inicio',
                    ),
                    _CeldaGrid(
                      color: Colors.orange,
                      icono: Icons.star,
                      texto: 'Favoritos',
                    ),
                    _CeldaGrid(
                      color: Colors.purple,
                      icono: Icons.person,
                      texto: 'Perfil',
                    ),
                    _CeldaGrid(
                      color: Colors.red,
                      icono: Icons.settings,
                      texto: 'Ajustes',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Clase auxiliar para las celdas del GridView =====
class _CeldaGrid extends StatelessWidget {
  final Color color;
  final IconData icono;
  final String texto;

  const _CeldaGrid({
    required this.color,
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: Colors.white, size: 36),
          const SizedBox(height: 8),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
