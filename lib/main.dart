import 'package:flutter/material.dart';
import 'package:neonime_app/components/splash.dart';

void main() {
  runApp(NeonimeApp());
}

class NeonimeApp extends StatefulWidget {
  @override
  _NeonimeAppState createState() => _NeonimeAppState();
}

class _NeonimeAppState extends State<NeonimeApp> {
  var num = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}