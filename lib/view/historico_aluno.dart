import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HistoricoAluno extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_aluno;
  final String matricula_aluno;
  final String nome_aluno;
  String nomeprof = "";

  HistoricoAluno({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_aluno, required this.nome_aluno, required this.matricula_aluno});
  var env_url = dotenv.env['URL'];
  List<dynamic> presenca = [];
  List<dynamic> estatisticas = [];

  Future<List<dynamic>> get_historico_aluno() async {
    var url = Uri.http('${env_url}', '/get_historico_aluno/$id_turma/$id_aluno');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[1]);
      temp.add(alunos[2]);
      presenca.add(temp);
    }

    var url2 = Uri.http('${env_url}', '/get_nomeprof_by_turmaid/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = '${responseData2[0][0]} ' + responseData2[0][1];

    var url3 = Uri.http('${env_url}', '/estatisticas_historico_aluno/$id_turma/$id_aluno');
    var response3 = await http.get(url3);
    List<dynamic> responseData3 = json.decode(response3.body);
    for (var info in responseData3) {
      List temp = [];
      temp.add(info[0]);
      temp.add(info[1]);
      temp.add(info[2]);
      temp.add(info[3]);
      print(info[3]);
      estatisticas.add(temp);
    }
  
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: get_historico_aluno(),
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
            presenca = snapshot.data!;
            return Scaffold(
              backgroundColor: ThemeColors.background,
              appBar: AppBar(
                title: buildText(text: 'Histórico de Chamadas', fontSize: 20, color: Colors.white, isBold: false),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          createRichText('Aulas:', "${estatisticas[0][0]}"),
                          createRichText('Presenças:', "${estatisticas[0][1]}"),
                          createRichText('Faltas:', "${estatisticas[0][2]}"),
                          TableCell(
                            child: Center(
                              child: estatisticas[0][3] == null
                                  ? createRichText('Percentual de faltas:', "0.00%")
                                  : createRichText('Percentual de faltas:', "${estatisticas[0][3]}%"),
                            ),
                            verticalAlignment: TableCellVerticalAlignment.middle,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          TableRow(children: [
                            createTableCellTittle('DATA'),
                            createTableCellTittle('PRESENTE'),
                            createTableCellTittle('JUSTIFICAR FALTA'),
                          ]),
                          for (var ocorrencia in presenca)
                          TableRow(children: [
                            TableCell(
                              child: Center(child: Text('${ocorrencia[1]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(
                                child: ocorrencia[2] == 'Presente'
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.close, color: Colors.red),
                              ),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(
                                child: ocorrencia[2] == 'Presente'
                                    ? Center(child: Text('', textAlign: TextAlign.center))
                                    : Icon(Icons.medical_services_outlined, color: Colors.red),
                              ),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
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
                      buildText(text: 'Aluno: ${nome_aluno}', fontSize: 16, color: Colors.white, isBold: false),
                      buildText(text: 'Matrícula: ${matricula_aluno}', fontSize: 16, color: Colors.white, isBold: false),
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
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: '$value'),
        ],
      ),
    );
}

Widget createTableCellTittle(String text) {
    return TableCell(
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
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