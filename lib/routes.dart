import 'package:chatapp/models.dart';
import 'package:flutter/material.dart';
import 'error.dart';
import 'loginsignup.dart';
import 'chat.dart';
import 'settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) =>
                LoginSignup('login', "Don't have an account?", '/signup'));
      case '/signup':
        return MaterialPageRoute(
            builder: (_) =>
                LoginSignup('signup', "Already have an account?", '/'));
      case '/chat':
        ModelLoginSignup arg = args;
        return MaterialPageRoute(
            builder: (_) => Chat(arg.username, arg.userid));
      case '/settings':
        ModelLoginSignup arg = args;
        return MaterialPageRoute(
            builder: (_) => Settings(arg.username, arg.userid));
      case '/error':
        return MaterialPageRoute(builder: (_) => Error(args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
            child: Text(
          'You seems to be lost',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        )),
      );
    });
  }
}
