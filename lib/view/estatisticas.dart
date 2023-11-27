import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Estatisticas extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  int num_alunos = 0;
  int num_aulas = 0;
  
  Estatisticas({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  String nomedisciplina = "";
  String nomeprof = "";
  String nome_professor = "";
  String matricula_professor = "";

  Future<List<dynamic>> visualizar_chamada() async {
    
    var url = Uri.http('${env_url}', '/estatisticas_prof/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    
    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[0]);
      temp.add(alunos[1]);
      temp.add(alunos[2]);
      temp.add(alunos[3]);
      temp.add(alunos[4]);
      temp.add(alunos[5]);
      alunos.add(temp);
    }

    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = responseData2[0][0];

    var url3 = Uri.http('${env_url}', '/get_numero_aulas/$id_turma');
    var response3 = await http.get(url3);
    List<dynamic> responseData3 = json.decode(response3.body);
    num_aulas = responseData3[0][0];

    var url4 = Uri.http('${env_url}', '/get_numero_alunos/$id_turma');
    var response4 = await http.get(url4);
    List<dynamic> responseData4 = json.decode(response4.body);
    num_alunos = responseData4[0][0];
  
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF005AAA),
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
              title: buildText(text: 'Estatísticas da turma', fontSize: 20, color: Colors.white, isBold: false),
                backgroundColor: Color(0xFF005AAA),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildText(text: 'UNIVERSIDADE FEDERAL FLUMINENSE', fontSize: 14, color: ThemeColors.text, isBold: true),
                      SizedBox(height: 10),
                      createRichText('PROFESSOR:', nomeprof),
                      SizedBox(height: 10),
                      createRichText('DISCIPLINA:', turmaChamada),
                      SizedBox(height: 10),
                      createRichText('TURMA:', codTurma),
                      SizedBox(height: 10),
                      createRichText('Nº DE ALUNOS:', "${num_alunos}"),
                      SizedBox(height: 10),
                      createRichText('Nº DE AULAS:', "${num_aulas}"),
                      SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          TableRow(children: [
                            createTableCellTittle('NOME'),
                            createTableCellTittle('MATRÍCULA'),
                            createTableCellTittle('% PRESENÇA'),
                            createTableCellTittle('PRESENÇAS'),
                            createTableCellTittle('FALTAS'),
                            createTableCellTittle('SITUAÇÃO'),
                          ]),
                          for (var aluno in alunos)
                          TableRow(children: [
                            createTableCell('${aluno[0]}'),
                            createTableCell('${aluno[1]}'),
                            createTableCell('${aluno[2]}'),
                            createTableCell('${aluno[3]}'),
                            createTableCell('${aluno[4]}'),
                            createTableCell('${aluno[5]}'),                          
                          ]),
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
                      buildText(text: 'Professor: ${nome_professor}', fontSize: 16, color: Colors.white, isBold: false),
                      buildText(text: 'Matrícula: ${matricula_professor}', fontSize: 16, color: Colors.white, isBold: false),
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
    child: Container(
      height: 40,
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
    ),
    verticalAlignment: TableCellVerticalAlignment.middle,
  );
}

Widget createTableCell(String text) {
  return TableCell(
    child: Container(
      height: 35,
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
    ),
    verticalAlignment: TableCellVerticalAlignment.middle,
  );
}

Widget createRichText(String label, String value) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 14,
        color: ThemeColors.text,
      ),
      children: <TextSpan>[
        TextSpan(
          text: '$label ',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Define a palavra em negrito
          ),
        ),
        TextSpan(text: '$value'),
      ],
    ),
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