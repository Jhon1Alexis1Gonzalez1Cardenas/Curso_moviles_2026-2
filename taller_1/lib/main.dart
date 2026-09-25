import 'package:flutter/material.dart';

void main() => runApp(const TallerApp());

class TallerApp extends StatelessWidget {
  const TallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1 - setState',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
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
  // Variable de estado: controla el título mostrado en el AppBar.
  String _titulo = 'Hola, Flutter';

  // Alterna el título del AppBar usando setState() y muestra un SnackBar.
  void _cambiarTitulo() {
    setState(() {
      _titulo = _titulo == 'Hola, Flutter'
          ? '¡Título cambiado!'
          : 'Hola, Flutter';
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Título actualizado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulo), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container decorando el nombre del estudiante (Text centrado).
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo, width: 1.5),
              ),
              child: const Text(
                'Jhon Alexis Gonzalez Cardenas', // TODO: reemplazar
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Row con las dos imágenes requeridas: network y asset.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Image.network(
                    'https://picsum.photos/200',
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Image.asset(
                    'assets/images/foto.jpg', // TODO: agregar la imagen real
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Botón obligatorio: dispara setState() + SnackBar.
            ElevatedButton.icon(
              onPressed: _cambiarTitulo,
              icon: const Icon(Icons.refresh),
              label: const Text('Cambiar título'),
            ),

            const SizedBox(height: 24),

            // Widget adicional 1: Stack -> texto superpuesto sobre imagen.
            const Text(
              'Widget adicional: Stack',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    'https://picsum.photos/400/200',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.black54,
                    child: const Text(
                      'mira un esta imagen ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Widget adicional 2: ListView con íconos y texto.
            const Text(
              'Widget adicional: ListView',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('StatefulWidget implementado'),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('setState() funcionando'),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('SnackBar mostrado al presionar el botón'),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Repositorio con ramas por taller'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
