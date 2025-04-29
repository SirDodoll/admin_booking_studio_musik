import 'package:admin_booking_application/screens/dashboard_screens.dart';
import 'package:admin_booking_application/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:admin_booking_application/theme/theme_data.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();

await Supabase.initialize(
  url: 'https://jzqgehgnhlljfmhdfrto.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6cWdlaGduaGxsamZtaGRmcnRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNTE4ODgsImV4cCI6MjA1NzkyNzg4OH0.YnLyoOCb81P2EpSfA2dz4JDEPzNKRCP2DdiiUDc5DZs',
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADMIN',
      theme: Styles.themeData(context),
      home: DashboardScreen(),
    );
  }
}