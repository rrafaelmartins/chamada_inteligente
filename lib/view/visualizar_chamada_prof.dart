import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VisualizarProf extends StatefulWidget {
  static String routeName = "/homealuno";
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  VisualizarProf({required this.id_turma, required this.id_professor, required this.codTurma, required this.turmaChamada});

  @override
  State<VisualizarProf> createState() => _VisualizarProfState(id_professor: id_professor, id_turma: id_turma, turmaChamada: turmaChamada, codTurma: codTurma);
}

class _VisualizarProfState extends State<VisualizarProf> {
  final String turmaChamada;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  var date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  
  _VisualizarProfState({required this.turmaChamada, required this.codTurma, required this.id_turma, required this.id_professor});
  var env_url = dotenv.env['URL'];
  List<dynamic> alunos = [];
  String nomedisciplina = "";
  String nomeprof = "";
  String nome_professor = "";
  String matricula_professor = "";
  int temppresenca = 0;

  Future<List<dynamic>> visualizar_chamada() async {
    
    var url = Uri.http('${env_url}', '/visualizar_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    for (var alunos in responseData) {
      List temp = [];
      temp.add(alunos[0]);
      temp.add(alunos[1]);
      temp.add(alunos[2]);
      alunos.add(temp);
    }

    var url2 = Uri.http('${env_url}', '/get_nome_prof/$id_professor');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nomeprof = responseData2[0][0];

    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData;
  }

   void togglePresencaAluno(String matricula, int presenca, int id_turma, int indexAluno) async {
      if (presenca == 0){
        var url10 = Uri.http('${env_url}', '/create_presenca_aluno/$id_turma/$matricula');
        var response10 = await http.post(url10);

        if(response10.statusCode == 200){
            setState(() {
              alunos[indexAluno][2] = presenca == 0 ? 1 : 0;
            });
        }
      }
      else{
        var url12 = Uri.http('${env_url}', '/delete_presenca_aluno/$id_turma/$matricula');
        var response12 = await http.delete(url12);

        if(response12.statusCode == 200){
              setState(() {
              alunos[indexAluno][2] = presenca == 0 ? 1 : 0;
            });
        }
      }

      visualizar_chamada();
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
              title: buildText(text: 'Visualizar Chamada', fontSize: 20, color: Colors.white, isBold: false),
                backgroundColor: Color(0xFF005AAA),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildText(text: 'UNIVERSIDADE FEDERAL FLUMINENSE', fontSize: 14, color: Colors.black, isBold: true),
                      SizedBox(height: 10),
                      createRichText('PROFESSOR:', nomeprof),
                      SizedBox(height: 10),
                      createRichText('DISCIPLINA:', turmaChamada),
                      SizedBox(height: 10),
                      createRichText('TURMA:', codTurma),
                      SizedBox(height: 10),
                      createRichText('DATA:', date),
                      SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1.0),
                        children: [
                          TableRow(children: [
                            createTableCellTittle('NOME'),
                            createTableCellTittle('MATRÍCULA'),
                            createTableCellTittle('PRESENÇA'),
                          ]),
                          for (var i = 0; i < alunos.length; i++)
                            TableRow(children: [
                              createTableCell('${alunos[i][0]}'),
                              createTableCell('${alunos[i][1]}'),
                              TableCell(
                                child: GestureDetector(
                                  onTap: () => togglePresencaAluno('${alunos[i][1]}', alunos[i][2], id_turma, i),
                                  child: Center(
                                    child: (alunos[i][2]  != 0)
                                      ? Icon(Icons.check, color: Colors.green)
                                      : Icon(Icons.close, color: Colors.red),
                                  ),
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

Widget createTableCell(String text) {
  return TableCell(
    child: Center(child: Text(text, textAlign: TextAlign.center)),
    verticalAlignment: TableCellVerticalAlignment.middle,
  );
}

Widget buildText({
  required String text,
  double fontSize = 14,
  Color color = Colors.black,
  bool isBold = false,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}