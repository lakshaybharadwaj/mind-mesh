import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://ubwqaygujaoeirsdvqye.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVid3FheWd1amFvZWlyc2R2cXllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNDA4MTgsImV4cCI6MjA2MDcxNjgxOH0.hUlYcJpEPW5ydHR488D9aSpVmsxxOQPhTrXKPuCuC0g',
  );
}
