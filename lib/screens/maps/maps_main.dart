import 'package:flutter/material.dart';
import './SignupOrLogin/signup_or_login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BOCK Maps',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignupOrLogin(),
    );
  }
}
