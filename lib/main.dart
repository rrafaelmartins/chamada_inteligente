import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'view/login.dart';

final routes = {
  LoginPage.routeName: (BuildContext context) => const LoginPage(),
};

Future<void> main() async{

  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    title: "Login",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.teal),
    initialRoute: LoginPage.routeName,
    routes: routes,
  ));
}