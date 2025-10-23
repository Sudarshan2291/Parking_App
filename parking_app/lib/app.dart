import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login/login_screen.dart';
import 'providers/login_provider.dart';

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        // Add other providers like ParkingProvider if needed
      ],
      child: MaterialApp(
        title: 'Parking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}
