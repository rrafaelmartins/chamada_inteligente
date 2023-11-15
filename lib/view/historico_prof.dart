import 'dart:convert';

import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HistoricoProfessor extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  var date = DateFormat.yMMMEd().format(DateTime.now());

  HistoricoProfessor({required this.turmaChamada, required this.codTurma});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];

  Future<List<dynamic>> get_historico() async {
    
    var url = Uri.http('${env_url}', '/get_historico/$turmaChamada');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[0]);
      temp.add(alunos[1]);
      alunos.add(temp);
    }
    
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Prof', style: TextStyle(color: ThemeColors.text)),
        backgroundColor: ThemeColors.appBar,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('UNIVERSIDADE FEDERAL FLUMINENSE', style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('PROFESSOR: LEONARDO MURTA', style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('DISCIPLINA: ' + turmaChamada, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('TURMA: ' + codTurma, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              // Tabela de chamada
              Table(
                border: TableBorder.all(color: Colors.grey, width: 1.0),
                children: [
                  // Headers da tabela
                  TableRow(children: [
                    TableCell(
                      child: Center(child: Text('DATA', textAlign: TextAlign.center)),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(child: Text('EXPORTAR', textAlign: TextAlign.center)),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Center(child: Text('14/11/2023', textAlign: TextAlign.center)),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Icon(Icons.download_sharp, color: Colors.blue),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Center(child: Text('16/11/2023', textAlign: TextAlign.center)),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Icon(Icons.download_sharp, color: Colors.blue),
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