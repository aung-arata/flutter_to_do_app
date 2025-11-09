import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/data/auth_service.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:to_do_app/pages/login_page.dart';
import 'package:to_do_app/pages/lock_screen.dart';

void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();

  // Open the box for storing todos and auth data
  await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUnlocked = false;
  bool _biometricRequired = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricRequirement();
  }

  Future<void> _checkBiometricRequirement() async {
    final prefs = await SharedPreferences.getInstance();
    final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    
    setState(() {
      _biometricRequired = biometricEnabled;
      _isUnlocked = !biometricEnabled;
      _isLoading = false;
    });
  }

  void _onUnlocked() {
    setState(() {
      _isUnlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    final authService = AuthService();
    final isLoggedIn = authService.isLoggedIn();

    return MaterialApp(
      home: _biometricRequired && !_isUnlocked
          ? LockScreen(onUnlocked: _onUnlocked)
          : (isLoggedIn ? const HomePage() : const LoginPage()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
    );
  }
}
