import 'dart:convert';

import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
            backgroundColor: ThemeColors.grey,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text('Carregando...', style: TextStyle(color: ThemeColors.text)),
              ],
            ),
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF005AAA),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, color: Colors.white, size: 30),
                  SizedBox(width: 10),                 
                  Padding(
                    padding: EdgeInsets.only(right: 60), // Adiciona margem à esquerda do texto
                    child: Text(
                      'Turmas',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),              
            ),
      body: Column(
          children: <Widget>[
            SizedBox(height: 100),
            Text(
              "Engenharia de Software II",
              style: TextStyle(
                fontSize: 18,
                color: ThemeColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Turma A1",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "DIA:",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "TER QUI",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "HORÁRIO:",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  child: Text(
                    "INÍCIO: ${startTime.format(context)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 50),
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
                  child: Text(
                    "FIM: ${endTime.format(context)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF005AAA),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  // Implement action on button press
                },
                child: Text(
                  "Salvar Alterações",
                  style: TextStyle(fontSize: 18),
                ),
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
              Text('Professor: ${nome_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              Text('Matrícula: ${matricula_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
            ],
          ),
        ),
      ),
    );
  }
});
}
}