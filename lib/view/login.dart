import 'dart:convert';
import 'package:chamada_inteligente/view/home_aluno.dart';
import 'package:chamada_inteligente/view/home_professor.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  String? _selectedRole;
  var env_url = dotenv.env['URL'];
  var value;

  Future<void> _submit() async {
    var url;

    if (_selectedRole == "Aluno"){
      url = Uri.http('${env_url}', '/LoginAluno');
    }
    else if (_selectedRole == "Professor"){
      url = Uri.http('${env_url}', '/LoginProfessor');
    }

    Map data = {
      'matricula': matricula,
      'senha': _password,
    };
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
        
    );
    dynamic responseData = json.decode(response.body);
    _navigateToCorrectPage(responseData);
  }

  void _navigateToCorrectPage(dynamic response) {
    if (response is List<dynamic>) {
      if (response.isNotEmpty) {
        if (_selectedRole == 'Aluno') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeAluno(id_aluno: response[0][0])),
            (route) => false,
          );
        } else if (_selectedRole == 'Professor') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeProfessor(id_professor: response[0][0])),
            (route) => false,
          );
        }
      }
    } else{
        _showFailDialog(context, "Login Inválido!\n\nVerifique Usuário e Senha!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildText(text: 'Login', fontSize: 20, color: Colors.white, isBold: false),
        backgroundColor: Color(0xFF005AAA),
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
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    FormInput(
                        label: "Usuário:",
                        textColor: Colors.black,
                        onChanged: (newValue) => matricula = newValue),
                    FormInput(
                        label: "Senha:",
                        textColor: Colors.black,
                        obscureText: true,
                        onChanged: (newValue) => _password = newValue),
                    SizedBox(height: 15),
                    DropdownButton<String>(
                      value: _selectedRole,
                      hint: buildText(text: 'Selecionar Tipo', fontSize: 16, color: Colors.black, isBold: true),
                      items: <String>['Aluno', 'Professor'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: buildText(text: 'Login', fontSize: 16, color: Colors.white, isBold: true),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF005AAA),
                        ),
                      ),
                    ),
                  ]),
                ),
              ]
            ),
          )
        )
      ),
    );
  }
}

class FormInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Color? textColor;

  const FormInput({
    required this.label,
    this.obscureText = false,
    this.onChanged,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

void _showFailDialog(BuildContext context, String texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: null,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            texto,
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text("OK",style: TextStyle(color: Color(0xFF005AAA)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget buildText({
  required String text,
  double fontSize = 14,
  Color color = Colors.black,
  bool isBold = false,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}