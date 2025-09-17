import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/hospital_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_hospital_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HospitalProvider(),
      child: MaterialApp(
        title: 'Türkiye Diş Hastaneleri',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
        routes: {
          '/add-hospital': (context) => const AddHospitalScreen(),
        },
      ),
    );
  }
}