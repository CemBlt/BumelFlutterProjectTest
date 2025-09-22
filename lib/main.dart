import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/hospital_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/appointment_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_hospital_screen.dart';
import 'screens/login_screen.dart';
import 'screens/my_appointments_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HospitalProvider()),
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
      ],
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
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (authProvider.isLoggedIn) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
        routes: {
          '/add-hospital': (context) => const AddHospitalScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}