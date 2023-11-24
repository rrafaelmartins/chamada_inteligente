import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Estatisticas extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  int num_alunos = 0;
  
  Estatisticas({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  String nomedisciplina = "";
  String nomeprof = "";
  String nome_professor = "";
  String matricula_professor = "";

    Future<List<dynamic>> visualizar_chamada() async {
    
    var url = Uri.http('${env_url}', '/estatisticas_prof/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    
    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[0]); //nome
      temp.add(alunos[1]); //matricula
      temp.add(alunos[2]); //porcentagem de presenca
      temp.add(alunos[3]); //numero de presencas
      temp.add(alunos[4]);
      if (alunos[5] == null){
        alunos[5] = "-";
        temp.add(alunos[5]);
      } //numero de faltas
      temp.add(alunos[5]); //situacao
      alunos.add(temp);
    }

    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = responseData2[0][0];

    var url4 = Uri.http('${env_url}', '/get_numero_alunos/$id_turma');
    var response4 = await http.get(url4);
    List<dynamic> responseData4 = json.decode(response4.body);
    num_alunos = responseData4[0][0];

    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
  return FutureBuilder<List<dynamic>>(
    future: visualizar_chamada(),
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
          alunos = snapshot.data!;
          return Scaffold(
            backgroundColor: ThemeColors.background,
            appBar: AppBar(
            title: Text('Estatísticas da turma', style: TextStyle(color: Colors.white)),
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
                      createRichText('Nº DE ALUNOS:', "${num_alunos}"),
                      SizedBox(height: 10),
                      // Tabela de chamada
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          // Headers da tabela
                          TableRow(children: [
                            createTableCellTittle('NOME'),
                            createTableCellTittle('MATRÍCULA'),
                            createTableCellTittle('% DE PRESENÇA'),
                            createTableCellTittle('N° DE PRESENÇAS'),
                            createTableCellTittle('N° DE FALTAS'),
                            createTableCellTittle('SITUAÇÃO'),
                           ]),
                          // Preencher de acordo com a quantidade de chamadas
                          for (var aluno in alunos)
                            TableRow(children: [
                              TableCell(
                                child: Center(child: Text('${aluno[0]}', textAlign: TextAlign.center)), //DATA
                                verticalAlignment: TableCellVerticalAlignment.middle,
                              ),
                              TableCell(
                                child: Center(child: Text('${aluno[1]}', textAlign: TextAlign.center)), //DATA
                                verticalAlignment: TableCellVerticalAlignment.middle,
                              ),
                              TableCell(
                                child: Center(child: Text('${aluno[2]}', textAlign: TextAlign.center)), //DATA
                                verticalAlignment: TableCellVerticalAlignment.middle,
                              ),
                              TableCell(
                                child: Center(child: Text('${aluno[3]}', textAlign: TextAlign.center)), //DATA
                                verticalAlignment: TableCellVerticalAlignment.middle,
                              ),
                              TableCell(
                                child: Center(child: Text('${aluno[4]}', textAlign: TextAlign.center)), //DATA
                                verticalAlignment: TableCellVerticalAlignment.middle,
                              ),
                              TableCell(
                                child: Center(child: Text('${aluno[5]}', textAlign: TextAlign.center)), //DATA
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
              Text('Professor: ${nome_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              Text('Matrícula: ${matricula_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
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