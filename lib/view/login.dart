import 'package:chamada_inteligente/view/home_page.dart';
import 'package:chamada_inteligente/form/form_input.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/login_controller.dart';
import '../helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';
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
  String? _email, _password;
  late LoginController controller;
  var value;

  _LoginPageState() {
    controller = LoginController();
  }

  void _submit() async {

  final dbHelper = DatabaseHelper();     //COMANDO PARA INICIAR O DB; TESTE APENAS
  await dbHelper.initDb();
  
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      try {
        User user = await controller.getLogin(_email!, _password!);
        if (user.id != -1) {
          savePref(1, user.id!, user.name, user.email, user.password);
          setState(() {
            _loginStatus = LoginStatus.signIn;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Usuário não registrado!")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
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

  _entrarSemConta() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
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
                              onChanged: (newValue) => _email = newValue),
                          FormInput(
                              label: "Senha",
                              obscureText: true,
                              onChanged: (newValue) => _password = newValue),
                          Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                  onPressed: _submit,
                                  child: const Text("Login"))),
                        ElevatedButton(
                              onPressed: () => {
                                    Navigator.pushNamed(
                                        context, CadastroPage.routeName)
                                  },
                              child: const Text("Cadastre-se")),
                        ]),
                      ),
                      GestureDetector(
                        onTap: _entrarSemConta,
                        child: Container(
                            margin: const EdgeInsets.only(top: 40),
                            child: const Text(
                              "Entrar sem uma conta",
                              style: TextStyle(color: Colors.cyan),
                            )),
                      )
                    ]),
              ))),
        );
      case LoginStatus.signIn:
        return const HomePage();
    }
  }
}
