import 'dart:convert';

import 'package:chamada_inteligente/view/login.dart';
import 'package:chamada_inteligente/view/view_turma.dart';
import 'package:flutter/material.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeProfessor extends StatefulWidget {
  static String routeName = "/homeprofessor";
  final int id_professor;
  HomeProfessor({required this.id_professor});


  @override
  State<HomeProfessor> createState() => _HomeProfessorState(id_professor: id_professor);
}

class _HomeProfessorState extends State<HomeProfessor> {
  // Lista de turmas para demonstração
  final int id_professor;
  _HomeProfessorState({required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> turmasBD = [];  // Lista para armazenar as turmas recebidas do BD
  
  Future<List<dynamic>> _getTurmas() async {
    var url = Uri.http('${env_url}', '/get_turmas_prof/$id_professor');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    print("entrou");
    for (var turma in responseData) {
      //print(turma);
      List temp = [];
      temp.add(turma[0]);
      temp.add(turma[1]);
      temp.add(turma[2]);
      /*String strid = turma[2].toString();
      temp.add(strid);
      print(strid.runtimeType);*/
      turmasBD.add(temp);
    }

    return responseData;
  }

  

  final List<Map<String, String>> turmas = [
    {
      'codigo': 'TCC00293 - Engenharia de Software II',
      'nome': 'Engenharia de Software II',
      'turma': 'Turma A1 - 2023.2'
    },
    {
      'codigo': 'TCC00339',
      'nome': 'Gerência de Projetos e Manutenção de Software',
      'turma': 'Turma A1 - 2023.2'
    }
    // ... Adicione mais turmas conforme necessário
  ];

 
  @override
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
                  Text('Turmas', style: TextStyle(color: ThemeColors.text)),
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: turmasBD.length,
              itemBuilder: (context, index) {
                return Card(
                  color: ThemeColors.formInput,
                  child: ListTile(
                    title: Text(
                      '${turmasBD[index][0]}',
                      style: TextStyle(color: ThemeColors.text),
                    ),
                    subtitle: Text(
                      'Turma: ${turmasBD[index][1]}',
                      style: TextStyle(color: ThemeColors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TurmaPage(disciplina: turmasBD[index][0]!, codTurma: turmasBD[index][1]!, id_turma: turmasBD[index][2]!, id_professor: id_professor),
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