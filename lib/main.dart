import 'package:admin_booking_application/screens/bookingAdmin.dart';
import 'package:admin_booking_application/screens/dashboard_screens.dart';
import 'package:admin_booking_application/providers/theme_providers.dart';
import 'package:admin_booking_application/screens/laporan.dart';
import 'package:admin_booking_application/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (
          context,
          themeProvider,
          child,
          ) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Admin',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const DashboardScreen(),
          routes: {
            BookingadminScreen.routName: (context) => const BookingadminScreen(),
            LaporanScreen.routName: (context) => const LaporanScreen(),
            SettingScreen.routName: (context) => const SettingScreen(),
          },
        );
      }),
    );
  }
}