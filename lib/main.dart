import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/auth/splashecran.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TravviteApp());
}

class TravviteApp extends StatelessWidget {
  const TravviteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travvite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2B4C7E),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B4C7E),
          primary: const Color(0xFF2B4C7E),
        ),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
