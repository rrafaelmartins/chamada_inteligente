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
  String nome_professor = "";
  String matricula_professor = "";
  
  Future<List<dynamic>> _getTurmas() async {
    var url = Uri.http('${env_url}', '/get_turmas_prof/$id_professor');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    print("entrou");
    for (var turma in responseData) {
      List temp = [];
      temp.add(turma[0]);
      temp.add(turma[1]);
      temp.add(turma[2]);
      turmasBD.add(temp);
    }

    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response2 = await http.get(url8);
    List<dynamic> responseData2 = json.decode(response2.body);
    nome_professor = responseData2[0][0];
    matricula_professor = "${responseData2[0][1]}";

    return responseData;
  }
 
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
                              TurmaPage(disciplina: turmasBD[index][0]!, codTurma: turmasBD[index][1]!, id_turma: turmasBD[index][2]!, id_professor: id_professor),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Color(0xFF005AAA),
          height: 30.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Professor: ${nome_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              Text('Matrícula: ${matricula_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
            ],
          ),
        ),
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