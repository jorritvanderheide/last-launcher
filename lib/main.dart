import 'package:flutter/material.dart';

void main() {
  runApp(const LastLauncherApp());
}

class LastLauncherApp extends StatelessWidget {
  const LastLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last Launcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Last Launcher'))),
    );
  }
}
