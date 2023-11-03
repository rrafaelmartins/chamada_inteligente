import 'dart:convert';

import 'package:chamada_inteligente/view/home_aluno.dart';
import 'package:chamada_inteligente/view/home_professor.dart';
import 'package:chamada_inteligente/form/form_input.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/login_controller.dart';
import '../helper/database_helper.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import 'cadastro.dart';

enum LoginStatus { notSignIn, signIn }

class LoginPage extends StatefulWidget {
  static String routeName = "/";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final _formKey = GlobalKey<FormState>();
  String? matricula, _password;
  late LoginController controller;
  var value;

  _LoginPageState() {
    controller = LoginController();
  }

  Future<http.Response> _submit() async {
    var url = Uri.http('192.168.0.104:5000', '/Login');

    Map data = {
    'matricula': matricula,
    'senha': _password,
  };
  //encode Map to JSON
  var body = json.encode(data);


  var response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );
    print(response.body);
    return response;
  }

  void _navigateToCorrectPage(User user) {
    if (user.is_teacher == "Aluno") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeAluno()),
        (route) => false,
      );
    } else if (user.is_teacher == "Professor") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeProfessor()),
        (route) => false,
      );
    } else {
      // Lidar com outros casos, se necessário
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  savePref(
      int value, int id, String username, String email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setInt("id", id);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("password", pass);
    });
  }


  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: ThemeColors.dark,
        centerTitle: true,
      ),
      backgroundColor: ThemeColors.background,
      body: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('images/logo.png', height: 200),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      FormInput(
                          label: "Usuário",
                          onChanged: (newValue) => matricula = newValue),
                      FormInput(
                          label: "Senha",
                          obscureText: true,
                          onChanged: (newValue) => _password = newValue),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                              onPressed: _submit, child: const Text("Login"))),
                      ElevatedButton(
                          onPressed: () => {
                                Navigator.pushNamed(
                                    context, CadastroPage.routeName)
                              },
                          child: const Text("Cadastre-se")),
                    ]),
                  ),
                ]),
          ))),
    );
  }
}
