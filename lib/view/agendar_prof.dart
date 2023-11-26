import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AgendarProfScreen extends StatefulWidget {
  @override
  final int id_professor;
  AgendarProfScreen({required this.id_professor});
  _AgendarProfScreenState createState() => _AgendarProfScreenState(id_professor: id_professor);
}

class _AgendarProfScreenState extends State<AgendarProfScreen> {
  _AgendarProfScreenState({required this.id_professor});
  String nome_professor = "";
  String matricula_professor = "";
  bool isCallActive = false;
  final int id_professor;
  var env_url = dotenv.env['URL'];
  TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 9, minute: 0);

  Future<List<dynamic>> get_nome_matricula_professor() async {
    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData8;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: get_nome_matricula_professor(),
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
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: buildText(text: 'Agendar Chamada', fontSize: 20, color: Colors.white, isBold: false),
              backgroundColor: Color(0xFF005AAA),
              centerTitle: true,
            ),
            body: Column(
              children: <Widget>[
                SizedBox(height: 100),
                buildInfoText("Engenharia de Software II", bold: true),
                buildInfoText("Turma A1", bold: true),
                SizedBox(height: 30),
                buildInfoText("DIA:", bold: true),
                buildInfoText("TER , QUI"),
                SizedBox(height: 30),
                buildInfoText("HORÁRIO:", bold: true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (selectedTime != null && selectedTime != startTime) {
                          setState(() {
                            startTime = selectedTime;
                          });
                        }
                      },
                      child: buildText(text: "INÍCIO: ${startTime.format(context)}", fontSize: 16, color: Colors.black, isBold: false),
                    ),
                    SizedBox(width: 30),
                    InkWell(
                      onTap: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (selectedTime != null && selectedTime != endTime) {
                          setState(() {
                            endTime = selectedTime;
                          });
                        }
                      },
                      child: buildText(text: "FIM: ${endTime.format(context)}", fontSize: 16, color: Colors.black, isBold: false),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF005AAA),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      // Implementar ação do botão
                    },
                    child: buildText(text: "Salvar Alterações", fontSize: 18, color: Colors.white, isBold: false),
                  ),
                ),
              ],
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
      },
    );
  }
}

Widget buildInfoText(String label, {bool bold = false}) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: bold ? ThemeColors.text : Colors.black,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
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