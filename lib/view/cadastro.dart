import 'package:chamada_inteligente/form/form_input.dart';
import 'package:flutter/material.dart';
import '../controller/cadastro_controller.dart';
import '../model/user.dart';
import '../styles/theme_colors.dart';

enum LoginStatus { notSignIn, signIn }

class CadastroPage extends StatefulWidget {
  static String routeName = "/cadastro";
  const CadastroPage({Key? key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _password, _matricula, _is_teacher, _selectedRole;
  late CadastroController controller;

  _CadastroPageState() {
    controller = CadastroController();
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      bool cadastrado = await controller.verifyEmail(_email!);
      bool matriculaexis = await controller.isMatriculaExist(_matricula!);

      if (cadastrado == true && matriculaexis == false) {
        User user = User(
            email: _email!,
            name: _name!,
            password: _password!,
            matricula: _matricula!,
            is_teacher: _is_teacher!);
        print(user.name);
        controller.saveUser(user);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastrado com sucesso')),
        );
      } else if (cadastrado == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário já cadastrado')),
        );
      } else if (matriculaexis == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Número de matrícula já existe')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
        backgroundColor: ThemeColors.dark,
        centerTitle: true,
      ),
      backgroundColor: ThemeColors.background,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('images/logo.png', height: 200),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormInput(
                        label: "Nome",
                        maxLines: 1,
                        onChanged: (value) => {_name = value},
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira seu nome!';
                          }
                          return null;
                        },
                      ),
                      FormInput(
                        label: "E-mail",
                        maxLines: 1,
                        onChanged: (value) => {_email = value},
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira seu e-mail!';
                          }
                          return null;
                        },
                      ),
                      FormInput(
                        label: "Senha",
                        maxLines: 1,
                        obscureText: true,
                        onChanged: (value) => {_password = value},
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira sua senha!';
                          }
                          return null;
                        },
                      ),
                      FormInput(
                        label: "Matrícula",
                        maxLines: 1,
                        obscureText: false,
                        onChanged: (value) => {_matricula = value},
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Insira sua senha!';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        hint: Text("Selecione um cargo"),
                        value: _selectedRole,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRole = newValue;
                            _is_teacher = newValue; // Use o valor selecionado
                          });
                        },
                        items: ["Professor", "Aluno"].map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um cargo';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: const Text("Cadastrar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
