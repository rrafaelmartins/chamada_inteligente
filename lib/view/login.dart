import 'dart:convert';
import 'package:chamada_inteligente/view/home_aluno.dart';
import 'package:chamada_inteligente/view/home_professor.dart';
import 'package:chamada_inteligente/form/form_input.dart';
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
      url = Uri.http('${env_url}', '/LoginProfessor'); //TODO: CRIAR ESSE ENDPOINT em login_manager.py
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
    print(response.body);

    List<dynamic> responseData = json.decode(response.body);
    _navigateToCorrectPage(responseData);
  }

  void _navigateToCorrectPage(List <dynamic> response) {
    if (response[0] != [] && _selectedRole == 'Aluno') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeAluno(id_aluno: response[0][0])),
        (route) => false,
      );
    } else if (response[0] != [] && _selectedRole == 'Professor') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeProfessor(id_professor: response[0][0])),
        (route) => false,
      );
    } else {
      // Handle the error or invalid login
      print("Invalid login or role not selected");
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  savePref(int value, int id, String username, String email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", value);
    preferences.setInt("id", id);
    preferences.setString("username", username);
    preferences.setString("email", email);
    preferences.setString("password", pass);
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
                        hint: Text('Selecionar Tipo',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                          child: const Text("Login"),
                          style: ElevatedButton.styleFrom(
                          primary: Color(0xFF005AAA), // Alterando a cor do botão para vermelho
                          // Outras propriedades do estilo do botão, se necessário
                      ),
                      ),
                    ),
                    ]),
                  ),
                ]),
          ))),
    );
  }
  
}

class FormInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Color? textColor; // Adicionando a cor do texto como uma propriedade

  const FormInput({
    required this.label,
    this.obscureText = false,
    this.onChanged,
    this.textColor, // Adicionando a cor do texto como um parâmetro opcional
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
          fontWeight: FontWeight.bold, // Usando a cor definida ou padrão (preto)
        ),
      ),
    );
  }
}