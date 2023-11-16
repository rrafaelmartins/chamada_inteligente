import 'dart:convert';

import 'package:chamada_inteligente/view/view_turma.dart';
import 'package:chamada_inteligente/view/view_turma_aluno.dart';
import 'package:chamada_inteligente/view/login.dart';
import 'package:flutter/material.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeAluno extends StatefulWidget {
  static String routeName = "/homealuno";
  final int id_aluno;
  HomeAluno({required this.id_aluno});


  @override
  State<HomeAluno> createState() => _HomeAlunoState(id_aluno: id_aluno);
}

class _HomeAlunoState extends State<HomeAluno> {
    final int id_aluno;
    _HomeAlunoState({required this.id_aluno});
    var env_url = dotenv.env['URL'];
  // Lista de turmas para demonstração (pode ser uma lista real)

  List<dynamic> turmasBD = [];  // Lista para armazenar as turmas recebidas do BD
  
  Future<List<dynamic>> _getTurmas() async {
    var url = Uri.http('${env_url}', '/get_turmas_aluno/$id_aluno');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    for (var turma in responseData) {
      List temp = [];
      temp.add(turma[0]);
      temp.add(turma[1]);
      turmasBD.add(temp);
    }

    return responseData;
  }

  Widget build(BuildContext context) {
  return FutureBuilder<List<dynamic>>(
    future: _getTurmas(),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
            backgroundColor: ThemeColors.grey,
            leading: IconButton(
              icon: Image.asset('images/logout.png'),
              onPressed: () {
                _logout(context);
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/chapeu.png', width: 30),
                SizedBox(width: 10),
                Text('Carregando...', style: TextStyle(color: ThemeColors.text)),
              ],
            ),
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          turmasBD = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF005AAA),
              leading: IconButton(
                icon: Icon(Icons.logout, color: Colors.white, size: 40),
                onPressed: () {
                  _logout(context);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, color: Colors.white, size: 30),
                  SizedBox(width: 10),                 
                  Padding(
                    padding: EdgeInsets.only(right: 60), // Adiciona margem à esquerda do texto
                    child: Text(
                      'Turmas',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ), 
            ),
            body: ListView.builder(
              itemCount: turmasBD.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xFFFbbc4e3),
                  child: ListTile(
                    title: Text(
                      '${turmasBD[index][0]}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Turma: ${turmasBD[index][1]}',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewTurmaAluno(disciplina: turmasBD[index][0]!, codTurma: turmasBD[index][1]!,),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      }
    },
  );
}

void _logout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => LoginPage(),
    ),
    (route) => false,
  );
}
}