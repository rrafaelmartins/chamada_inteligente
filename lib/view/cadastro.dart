
import 'package:chamada_inteligente/form/form_input.dart';
import 'package:flutter/material.dart';
import '../controller/cadastro_controller.dart';
import '../model/user.dart';
import '../styles/theme_colors.dart';

enum LoginStatus { notSignIn, signIn }

class CadastroPage extends StatefulWidget {
  static String routeName = "/cadastro";
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _password, matricula;
  int? is_teacher;
  late CadastroController controller;

  _CadastroPageState() {
    controller = CadastroController();
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      bool cadastrado = await controller.verifyEmail(_email!);
      if (cadastrado) {
        User user = User(email: _email!, name: _name!, password: _password!, matricula: matricula!, is_teacher: is_teacher!);
        controller.saveUser(user);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastrado com sucesso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário já cadastrado')),
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
                    child: Column(children: [
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
                          }),
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
                          }),
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
                          }),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                              onPressed: _submit,
                              child: const Text("Cadastrar")))
                    ]),
                  ),
                ]),
          ))),
    );
  }
}
