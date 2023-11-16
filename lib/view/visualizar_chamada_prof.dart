import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VisualizarProf extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  var date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  
  VisualizarProf({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  String nomedisciplina = "";
  String nomeprof = "";

    Future<List<dynamic>> get_historico() async {
    
    var url = Uri.http('${env_url}', '/get_historico/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[0]); //matricula
      temp.add(alunos[1]); //primeiro nome
      temp.add(alunos[2]); //segundo nome
      alunos.add(temp);
    }

    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);


    nomeprof = responseData2[0][0];
    return responseData;
  }

  Future<void>_getNome() async {
    var url = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);


    nomeprof = responseData[0];

    print(nomeprof);
  }

  @override
  Widget build(BuildContext context) {
return FutureBuilder<List<dynamic>>(
    future: get_historico(),
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
                          TextSpan(text: date),
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
                        for (var aluno in alunos)
                          TableRow(children: [
                            TableCell(
                              child: Center(child: Text('${aluno[1]} ' + '${aluno[2]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(child: Text('${aluno[0]}', textAlign: TextAlign.center)),
                              verticalAlignment: TableCellVerticalAlignment.middle,
                            ),
                            TableCell(
                              child: Center(
                                child: Icon(Icons.check, color: Colors.green),
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

/*

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
              Text('PROFESSOR: LEONARDO MURTA', style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('DISCIPLINA: ' + turmaChamada, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('TURMA: ' + codTurma, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('Data: ' + date, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),

              // Tabela de chamada
              Table(
                border: TableBorder.all(color: Colors.grey, width: 1.0),
                children: [
                  // Headers da tabela
                  TableRow(children: [
                    Text('NOME', textAlign: TextAlign.center),
                    Text('MATRÍCULA', textAlign: TextAlign.center),
                    Text('PRESENÇA', textAlign: TextAlign.center),
                    Text('JUSTIFICAR FALTA', textAlign: TextAlign.center),
                  ]),
                  // Dados dos alunos
                  for (var aluno in alunos)
                    TableRow(children: [
                      Text('${aluno['primeiro_nome']}', textAlign: TextAlign.center), // Substituir pelo nome do aluno vindo do banco de dados
                      Text('${aluno['matricula']}', textAlign: TextAlign.center), // Substituir pela matrícula do aluno vinda do banco de dados
                      Icon(Icons.close, color: Colors.red), // Use Icons.check para presença; Aqui ocorrerá a chamada ao BD
                      Text('', textAlign: TextAlign.center), // Deixe em branco se não houver justificativa
                    ]),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



*/