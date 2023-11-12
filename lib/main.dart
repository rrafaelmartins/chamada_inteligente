import 'package:chamada_inteligente/view/cadastro.dart';
import 'package:chamada_inteligente/view/home_professor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'view/login.dart';
import 'helper/database_helper.dart';

final routes = {
  LoginPage.routeName: (BuildContext context) => const LoginPage(),
  
  
};

void main() {
  runApp(MaterialApp(
    title: "Login",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.teal),
    initialRoute: LoginPage.routeName,
    routes: routes,
  ));
}
