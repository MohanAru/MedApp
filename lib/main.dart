import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medapp/Route.dart';
import 'LoginPage.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return const MaterialApp(
      // theme: ThemeData(brightness: Brightness.dark,primaryColor: Colors.blue),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
