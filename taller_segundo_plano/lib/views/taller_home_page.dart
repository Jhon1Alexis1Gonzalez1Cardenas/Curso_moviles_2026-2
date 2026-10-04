import 'package:flutter/material.dart';
import 'future_page.dart';
import 'cronometro_page.dart';
import 'isolate_page.dart';

class TallerHomePage extends StatelessWidget {
  const TallerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Taller Segundo Plano'),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.cloud_download), text: 'Future'),
            Tab(icon: Icon(Icons.timer), text: 'Timer'),
            Tab(icon: Icon(Icons.memory), text: 'Isolate'),
          ]),
        ),
        body: const TabBarView(children: [
          FuturePage(),
          CronometroPage(),
          IsolatePage(),
        ]),
      ),
    );
  }
}
