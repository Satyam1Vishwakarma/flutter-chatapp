import 'package:chatapp/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dis U',
      theme: ThemeData(
        fontFamily: 'Nunito',
        primaryColor: Color(0xff1c2e46),
        accentColor: Color(0xff1c2e46),
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
