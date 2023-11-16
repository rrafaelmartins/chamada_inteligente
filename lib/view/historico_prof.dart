import 'dart:convert';

import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HistoricoProfessor extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_professor;
  String nomeprof = "";

  HistoricoProfessor({required this.turmaChamada, required this.codTurma, required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];

  Future<void>_getNome() async {
    var url = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    nomeprof = responseData[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    TableCell(
                      child: Center(child: Text("DATA", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(child: Text("EXPORTAR", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}