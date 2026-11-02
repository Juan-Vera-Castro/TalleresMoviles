import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to the Home Dashboard',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              // Lee la versión del APK instalado (version de pubspec.yaml)
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final info = snapshot.data!;
                  return Chip(
                    avatar: const Icon(Icons.verified, size: 18),
                    label: Text(
                      'Versión ${info.version} (build ${info.buildNumber})',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
