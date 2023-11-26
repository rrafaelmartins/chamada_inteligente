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
  int num_aulas = 0;
  List<dynamic> datas = [];
  List<dynamic> percentual = [];

  HistoricoProfessor({required this.turmaChamada, required this.codTurma, required this.id_professor, required this.id_turma});
  var env_url = dotenv.env['URL'];
  String nome_professor = "";
  String matricula_professor = "";

  Future<List<dynamic>> get_historico_aluno() async {
    
    var url = Uri.http('${env_url}', '/get_datas_historico_prof/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    for (var registro in responseData) {
      List temp = [];
      temp.add(registro[0]);
      datas.add(temp);
    }

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

    var url4 = Uri.http('${env_url}', '/get_numero_aulas/$id_turma');
    var response4 = await http.get(url4);
    List<dynamic> responseData4 = json.decode(response4.body);
    num_aulas = responseData4[0][0];

    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData;
  }

  void export_chamada(BuildContext context, String data) async {

    //Esta não é a forma optimal. Deveria verificar qual o caminho adequado de cada dispositivo, mas não foi possível.
    DateTime dataObjeto = DateFormat("dd/MM/yyyy").parse(data);
    String dataFormatada = DateFormat("yyyy-MM-dd").format(dataObjeto);
    var url12 = Uri.http('${env_url}', '/export_chamada/$id_turma/$dataFormatada');
    var response12 = await http.get(url12);

    if (response12.statusCode == 200){
      _showChamadaDialog(context, "Chamada exportada com sucesso!");
    }
    else{
      _showChamadaDialog(context, "Ocorreu um erro. Tente novamente!");
    }
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
            datas = snapshot.data!;
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
                      createRichText('Nº DE AULAS:', "${num_aulas}"),
                      SizedBox(height: 10),
                      Table(
                      border: TableBorder.all(color: Colors.grey, width: 1.0),
                      children: [
                        TableRow(
                          children: [
                          createTableCellTittle('DATA'),
                          createTableCellTittle('% DE PRESENÇA'),
                          createTableCellTittle('VISUALIZAR'),
                          createTableCellTittle('EXPORTAR'),
                        ]),
                        for (var data in datas)
                          TableRow(children: [
                            createTableCell('${data[0]}'),
                            createTableCell('${percentual[0][0]}'),
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
                              child: GestureDetector(
                                onTap: () {
                                  export_chamada(context, data[0]);
                                },
                                child: Icon(Icons.download_sharp, color: Colors.black),
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

void _showChamadaDialog(BuildContext context, String texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: null,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            texto,
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text("OK",style: TextStyle(color: Color(0xFF005AAA)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget buildText({ required String text, double fontSize = 14 ,Color color = Colors.black ,bool isBold = false}){
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}