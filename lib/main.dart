import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trial/screens/auth_screen.dart';
import 'package:trial/screens/home_screen.dart';
import 'package:trial/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final savedUsername = prefs.getString('loggedInUsername');
  runApp(MyApp(initialUsername: savedUsername));
}

class MyApp extends StatelessWidget {
  final String? initialUsername;
  const MyApp({super.key,required this.initialUsername});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialUsername != null
          ? HomeScreen(userName: initialUsername!)
          : const AuthScreen(),
    );
  }
}
