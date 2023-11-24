import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:chamada_inteligente/view/chamada_passada.dart';
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
  List<dynamic> percentual = [];

  HistoricoProfessor({required this.turmaChamada, required this.codTurma, required this.id_professor, required this.id_turma});
  var env_url = dotenv.env['URL'];

    Future<List<dynamic>> get_historico_aluno() async {
    
    //get historico
    var url = Uri.http('${env_url}', '/get_datas_historico_prof/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    for (var registro in responseData) {
      List temp = [];
      temp.add(registro[0]);
      datas.add(temp);
    }

  
    //get nomeprof
    var url2 = Uri.http('${env_url}', '/get_nomeprof_by_turmaid/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = '${responseData2[0][0]} ' + responseData2[0][1];


    var url3 = Uri.http('${env_url}', '/get_percentual_presenca_turma/$id_turma');
    var response3 = await http.get(url3);
    List<dynamic> responseData3 = json.decode(response3.body);
    for (var percent in responseData3) {
      List temp = [];
      temp.add(percent[0]);
      percentual.add(temp);
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
                Table(
                border: TableBorder.all(color: Colors.grey, width: 1.0),
                children: [
                  // Headers da tabela
                  TableRow(
                    children: [
                    createTableCellTittle('DATA'),
                    createTableCellTittle('% DE PRESENÇA'),
                    createTableCellTittle('VISUALIZAR'),
                    createTableCellTittle('EXPORTAR'),
                  ]),
                  for (var data in datas)
                    TableRow(children: [
                      TableCell(
                        child: Center(child: Text('${data[0]}', textAlign: TextAlign.center)),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                        TableCell(
                        child: Center(child: Text('${percentual[0][0]}', textAlign: TextAlign.center)), //PERCENTUAL DE PRESENÇA
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChamadaPassada(
                                turmaChamada: turmaChamada.toUpperCase(),
                                codTurma: codTurma.toUpperCase(),
                                id_turma: id_turma,
                                id_professor: this.id_professor,
                                data: data[0],
                              )),
                            );
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.black),
                        ),
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

Widget createTableCellTittle(String text) {
  return TableCell(
    child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
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