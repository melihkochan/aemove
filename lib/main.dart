import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:adapty_flutter/adapty_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await Adapty().activate(
      configuration: AdaptyConfiguration(
        apiKey: 'public_live_jKcUTMIc.CUKMukohyEeQE6tNkdrG',
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('Adapty aktivasyonu başarısız: $error');
    debugPrint('$stackTrace');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aemove',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShell(),
    );
  }
}
