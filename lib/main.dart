import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mind_mesh/widgets/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ubwqaygujaoeirsdvqye.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVid3FheWd1amFvZWlyc2R2cXllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNDA4MTgsImV4cCI6MjA2MDcxNjgxOH0.hUlYcJpEPW5ydHR488D9aSpVmsxxOQPhTrXKPuCuC0g',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bunny Login',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
