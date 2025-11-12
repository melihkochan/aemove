import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AemoveApp());
}

class AemoveApp extends StatelessWidget {
  const AemoveApp({super.key});

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
