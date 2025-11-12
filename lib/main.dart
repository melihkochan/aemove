import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'screens/main_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AemoveApp(),
    ),
  );
}

class AemoveApp extends StatelessWidget {
  const AemoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app.name'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MainShell(),
    );
  }
}
