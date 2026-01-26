import 'package:flutter/material.dart';
import 'features/health_record/health_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Record OCR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HealthRecordScreen(),
    );
  }
}
