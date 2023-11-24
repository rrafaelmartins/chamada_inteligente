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

  
  ChamadaPassada({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor, required this.data});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  List<dynamic> alunos_chamada = [];
  String nomedisciplina = "";
  String nomeprof = "";

    Future<List<dynamic>> visualizar_chamada() async {
    
    //pegar nome prof
    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = responseData2[0][0];

    Map payload = {
      'data': '$data',
    };
    var body = json.encode(payload);
    print(data);

    DateTime dataObjeto = DateFormat("dd/MM/yyyy").parse(data);
    String dataFormatada = DateFormat("yyyy-MM-dd").format(dataObjeto);
    
    var url3 = Uri.http('${env_url}', '/chamada_passada/$id_turma/$dataFormatada');
    var response3 = await http.get(url3);

    List<dynamic> responseData3 = json.decode(response3.body);
    print(response3.body);

    for (var aluno in responseData3) {
      List temp = [];
      temp.add(aluno[0]); //nome
      temp.add(aluno[1]); //matricula
      temp.add(aluno[2]); //presenca
      print("sdadsasdadsa");
      print(aluno[1]);
      print(aluno[2]);
      alunos_chamada.add(temp);
    }
    return responseData3;
  }

  @override
  Widget build(BuildContext context) {
return FutureBuilder<List<dynamic>>(
    future: visualizar_chamada(),
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
          alunos = snapshot.data!;
          return Scaffold(
            backgroundColor: ThemeColors.background,
            appBar: AppBar(
            title: Text('Visualizar Chamada', style: TextStyle(color: Colors.white)),
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
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeColors.text,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'DATA: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Define a palavra "DATA" em negrito
                            ),
                          ),
                          TextSpan(text: data),
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
                          createTableCellTittle('NOME'),
                          createTableCellTittle('MATRÍCULA'),
                          createTableCellTittle('PRESENÇA'),
                        ]),
                        // Dados dos alunos
                        for (var aluno in alunos_chamada)
                          TableRow(children: [
                            TableCell(
                              child: Center(child: Text('${aluno[0]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(child: Text('${aluno[1]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
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