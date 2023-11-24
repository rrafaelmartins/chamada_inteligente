import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoricoAluno extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_aluno;
  final String nome_aluno;
  final String matricula_aluno;
  String nomeprof = "";

  HistoricoAluno({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_aluno, required this.nome_aluno, required this.matricula_aluno});
  var env_url = dotenv.env['URL'];
  List<dynamic> presenca = [];

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

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: get_historico_aluno(),
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
            presenca = snapshot.data!;
            return Scaffold(
              backgroundColor: ThemeColors.background,
              appBar: AppBar(
                title: Text('Histórico de Chamadas', style: TextStyle(color: Colors.white)),
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
                      createRichText('PROFESSOR:', nomeprof),
                      SizedBox(height: 10),
                      createRichText('DISCIPLINA:', turmaChamada),
                      SizedBox(height: 10),
                      createRichText('TURMA:', codTurma),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha os elementos à esquerda e à direita
                        children: [
                          createRichText('Aulas:', codTurma),
                          createRichText('Presenças:', codTurma),
                          createRichText('Faltas:', codTurma),
                          createRichText('Percentual de faltas:', codTurma),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Tabela de chamada
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          // Headers da tabela
                          TableRow(children: [
                            createTableCellTittle('DATA'),
                            createTableCellTittle('PRESENTE'),
                            createTableCellTittle('JUSTIFICAR FALTA'),
                          ]),
                          // Preencher de acordo com a quantidade de chamadas
                          for (var ocorrencia in presenca)
                            TableRow(children: [
                              TableCell(
                                child: Center(child: Text('${ocorrencia[1]}', textAlign: TextAlign.center)), //DATA
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
              Text('Aluno: ${nome_aluno}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              Text('Matrícula: ${matricula_aluno}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
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
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
      verticalAlignment: TableCellVerticalAlignment.middle,
    );
  }
}
