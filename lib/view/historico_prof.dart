import 'dart:convert';

import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:chamada_inteligente/view/historico_aluno.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HistoricoProfessor extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_professor;
  final int id_turma;
  String nomeprof = "";
  List<dynamic> datas = [];

  HistoricoProfessor({required this.turmaChamada, required this.codTurma, required this.id_professor, required this.id_turma});
  var env_url = dotenv.env['URL'];

    Future<List<dynamic>> get_historico_aluno() async {
    
    var url = Uri.http('${env_url}', '/get_datas_historico_prof/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    //print("consulta 1:");
    //print(responseData);
    for (var registro in responseData) {
      List temp = [];
      temp.add(registro[0]);
      datas.add(temp);
      print("temp:");
      print(temp);
    }
    print("responseData:");
    print(responseData);

    //print("aqui aqui");
    //print(datas);
    
    var url2 = Uri.http('${env_url}', '/get_nomeprof_by_turmaid/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);

    print("consulta 2:");
    print(responseData2);
    nomeprof = '${responseData2[0][0]} ' + responseData2[0][1];
    print(nomeprof);
    
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
          datas = snapshot.data!;
          print("asdadsasd");
          print(datas);
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
                    createTableCellTittle('EXPORTAR'),
                  ]),
                  // for (var aluno in alunos) // Preencher de acordo com a quantidade de chamadas
                  for (var data in datas)
                          TableRow(children: [
                            TableCell(
                              child: Center(child: Text('${data[0]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Icon(Icons.download_sharp, color: Colors.blue),
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