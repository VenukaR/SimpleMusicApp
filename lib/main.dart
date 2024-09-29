import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:simple_music_player/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Dispose of services and resources here if needed
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CalmWave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Circular Std",
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        useMaterial3: false,
      ),
      home: const SplashView(),
    );
  }
}
