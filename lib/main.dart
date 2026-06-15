import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/hive_storage_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorageService.instance.init();
  runApp(const JobCraftApp());
}

class JobCraftApp extends StatelessWidget {
  const JobCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JobCraft CV',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
