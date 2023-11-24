import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VisualizarProf extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  var date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  
  VisualizarProf({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  String nomedisciplina = "";
  String nomeprof = "";
  String nome_professor = "";
  String matricula_professor = "";

    Future<List<dynamic>> visualizar_chamada() async {
    
    var url = Uri.http('${env_url}', '/visualizar_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    print("aqui");
    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[0]); //nome
      temp.add(alunos[1]); //matricula
      temp.add(alunos[2]); //presenca
      print("sdadsasdadsa");
      print(alunos[1]);
      print(alunos[2]);
      alunos.add(temp);
    }

    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = responseData2[0][0];

    
    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData;
  }


  @override
  Widget build(BuildContext context) {
return FutureBuilder<List<dynamic>>(
    future: visualizar_chamada(),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
          title: Text('Visualizar Chamada', style: TextStyle(color: ThemeColors.text)),
          backgroundColor: ThemeColors.appBar,
      ),
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          alunos = snapshot.data!;
          return Scaffold(
            backgroundColor: ThemeColors.background,
            appBar: AppBar(
            title: Text('Visualizar Chamada', style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xFF005AAA),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('UNIVERSIDADE FEDERAL FLUMINENSE', style: TextStyle(fontSize: 14, color: ThemeColors.text, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeColors.text,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'PROFESSOR: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Define a palavra "PROFESSOR" em negrito
                            ),
                          ),   
                          TextSpan(text: '${nomeprof}'),               
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeColors.text,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'DISCIPLINA: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Define a palavra "DISCIPLINA" em negrito
                            ),
                          ),
                          TextSpan(text: turmaChamada),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeColors.text,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'TURMA: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Define a palavra "TURMA" em negrito
                            ),
                          ),
                          TextSpan(text: codTurma),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeColors.text,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'DATA: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Define a palavra "DATA" em negrito
                            ),
                          ),
                          TextSpan(text: date),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // Tabela de chamada
                    Table(
                      border: TableBorder.all(color: Colors.grey, width: 1.0),
                      children: [
                        // Headers da tabela
                        TableRow(children: [
                          createTableCellTittle('NOME'),
                          createTableCellTittle('MATRÍCULA'),
                          createTableCellTittle('PRESENÇA'),
                        ]),
                        // Dados dos alunos
                        for (var aluno in alunos)
                          TableRow(children: [
                            TableCell(
                              child: Center(child: Text('${aluno[0]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(child: Text('${aluno[1]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(
                                child: aluno[2] != 0
                                  ? Center(child: Icon(Icons.check, color: Colors.green))
                                  : Icon(Icons.close, color: Colors.red),
                              ),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                          ]
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
}

Widget createTableCellTittle(String text) {
  return TableCell(
    child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
    verticalAlignment: TableCellVerticalAlignment.middle,
  );
}