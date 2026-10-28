import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nioudem/firebase_options.dart';
import 'package:nioudem/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(const SirayaApp());
}
