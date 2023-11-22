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
  String nomeprof = "";
  var date = DateFormat.yMMMEd().format(DateTime.now());

  HistoricoAluno({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_aluno});
  var env_url = dotenv.env['URL'];
  List<dynamic> presenca = [];

  Future<List<dynamic>> get_historico_aluno() async {
    
    var url = Uri.http('${env_url}', '/get_historico_aluno/$id_turma/$id_aluno');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    print("consulta 1:");
    print(responseData);
    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[1]);
      temp.add(alunos[2]);
      presenca.add(temp);
      print(temp);
    }

    print("aqui aqui");
    print(presenca);
    

    var url2 = Uri.http('${env_url}', '/get_nomeprof_by_turmaid/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);

    print("consulta 2:");
    print(responseData2);
    nomeprof = '${responseData2[0][0]} ' + responseData2[0][1];
    print(nomeprof);
    
    return responseData;
  }

    /*Future<void>_getNome() async {
    var url = Uri.http('${env_url}', '/get_nomeprof_by_turmaid/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    nomeprof = responseData[0];
  }*/


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
          print("xereca broder");
          print(presenca);
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
                  // for (var aluno in alunos) // Preencher de acordo com a quantidade de chamadas
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
