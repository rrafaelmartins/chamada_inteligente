import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HistoricoAluno extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;

  HistoricoAluno({required this.turmaChamada, required this.codTurma});
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
                          TextSpan(text: 'nome prof bd'),
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
                  TableRow(children: [
                    TableCell(
                      child: Center(child: Text('data do vetor', textAlign: TextAlign.center)),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Icon(Icons.check, color: Colors.green),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Center(
                        child: Icon(Icons.medical_services_outlined, color: Colors.red),
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

Widget createTableCellTittle(String text) {
  return TableCell(
    child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),)),
    verticalAlignment: TableCellVerticalAlignment.middle,
  );
}
