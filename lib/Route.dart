// ignore: file_names
import 'package:flutter/material.dart';
import 'package:medapp/BillerPage.dart';
import 'package:medapp/Inventry.dart';
import 'package:medapp/LoginPage.dart';
import 'package:medapp/ManagerPage.dart';
import 'package:medapp/SystemAd.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) =>const LoginPage(),
        );
      case '/manager':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ManagerPage(username: args),
          );
        }
        return _errorRoute();
      case '/biller':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BillerPage(username: args),
          );
        }
        return _errorRoute();
      case '/inventory':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Inventry(username: args),
          );
        }
        return _errorRoute();
      case '/systemadmin':
        return MaterialPageRoute(
          builder: (_) => const SystemAd(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Text('Error: Unknown route'),
          ),
        );
      },
    );
  }
}
