import 'package:chamada_inteligente/view/cadastro.dart';
import 'package:chamada_inteligente/view/home_professor.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'view/login.dart';
import 'helper/database_helper.dart';

final routes = {
  LoginPage.routeName: (BuildContext context) => const LoginPage(),
  CadastroPage.routeName: (BuildContext context) => const CadastroPage(),
  HomeProfessor.routeName: (BuildContext context) => const HomeProfessor(),

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
