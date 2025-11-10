// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/auth_wrapper.dart';
import 'services/model_manager.dart';
import 'services/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Use MultiProvider to provide both managers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ModelManager()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: const SnakeIdentifierApp(),
    ),
  );
}

class SnakeIdentifierApp extends StatelessWidget {
  const SnakeIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. "Watch" the ThemeManager
    final themeManager = context.watch<ThemeManager>();

    return MaterialApp(
      title: 'Snake Identifier',

      // 5. Set the theme properties
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light, // light theme
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark, // dark theme
        ),
        useMaterial3: true,
      ),
      themeMode: themeManager.themeMode,

      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}