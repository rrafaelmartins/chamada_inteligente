import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChamadaPassada extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  final String data;
  final int id_aula;

  ChamadaPassada({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor, required this.data, required this.id_aula});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  List<dynamic> alunos_chamada = [];
  String nomedisciplina = "";
  String nomeprof = "";
  String nome_professor = "";
  String matricula_professor = "";

  Future<List<dynamic>> visualizar_chamada() async {
    
    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = responseData2[0][0];

    Map payload = {
      'data': '$data',
    };
    var body = json.encode(payload);
    
    var url3 = Uri.http('${env_url}', '/chamada_passada/$id_turma/$id_aula');
    var response3 = await http.get(url3);

    List<dynamic> responseData3 = json.decode(response3.body);

    for (var aluno in responseData3) {
      List temp = [];
      temp.add(aluno[0]);
      temp.add(aluno[1]);
      temp.add(aluno[2]);
      alunos_chamada.add(temp);
    }

    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";
    
    return responseData3;
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
              title: buildText(text: 'Visualizar Chamada', fontSize: 20, color: Colors.white, isBold: false),
                backgroundColor: Color(0xFF005AAA),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildText(text: 'UNIVERSIDADE FEDERAL FLUMINENSE',fontSize: 14,color: ThemeColors.text,isBold: true),
                      SizedBox(height: 10),
                      createRichText('PROFESSOR:', nomeprof),
                      SizedBox(height: 10),
                      createRichText('DISCIPLINA:', turmaChamada),
                      SizedBox(height: 10),
                      createRichText('TURMA:', codTurma),
                      SizedBox(height: 10),
                      createRichText('DATA:', data),
                      SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          TableRow(children: [
                            createTableCellTittle('NOME'),
                            createTableCellTittle('MATRÍCULA'),
                            createTableCellTittle('PRESENÇA'),
                          ]),
                          for (var aluno in alunos_chamada)
                            TableRow(children: [
                              createTableCell('${aluno[0]}'),
                              createTableCell('${aluno[1]}'),
                              TableCell(
                                child: Center(
                                  child: aluno[2] == "Presente"
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

Widget createTableCellTittle(String text) {
  return TableCell(
    child: Container(
      height: 20,
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
    ),
    verticalAlignment: TableCellVerticalAlignment.middle,
  );
}

Widget createTableCell(String text) {
  return TableCell(
    child: Center(child: Text(text, textAlign: TextAlign.center)),
    verticalAlignment: TableCellVerticalAlignment.middle,
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