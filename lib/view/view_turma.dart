import 'dart:convert';
import 'package:chamada_inteligente/view/agendar_prof.dart';
import 'package:chamada_inteligente/view/historico_prof.dart';
import 'package:chamada_inteligente/view/visualizar_chamada_prof.dart';
import 'package:chamada_inteligente/view/estatisticas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TurmaPage extends StatelessWidget {
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  String ?localizacao;
  String nome_professor = "";
  String matricula_professor = "";
  var env_url = dotenv.env['URL'];

  TurmaPage({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_professor});

  Future<List<dynamic>> get_nome_matricula_professor() async {
    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData8;
  }

  Future<Map<String, dynamic>> _iniciarChamada(BuildContext context) async {
    var url2 = Uri.http('${env_url}', '/check_open_chamadas/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    
    if (responseData2[0][0] == 0){

    var url = Uri.http('${env_url}', '/iniciar_chamada/${id_turma}/');

    await Geolocator.requestPermission();
    await Geolocator.checkPermission();

    Position prof_position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    localizacao = '${prof_position.latitude},${prof_position.longitude}';

    Map data = {
      'localizacao': localizacao,
    };
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    if (response.statusCode == 200) {
      _showSuccessDialog(context, "Chamada iniciada!");
    }
    else{
      _showFailDialog(context, "Ocorreu um erro. Tente novamente!");
    }

    Map<String, dynamic> responseData = json.decode(response.body);
    
    return responseData;
    }
    else{
      _showFailDialog(context, "Já existe uma chamada em aberto!");
    }
    
    return {'status': 'chamada_nao_iniciada', 'data': responseData2};
  }

  Future<List<dynamic>> _finalizarChamada(BuildContext context) async {

    var url2 = Uri.http('${env_url}', '/check_open_chamadas/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);

    if (responseData2[0][0] == 1){
    var url = Uri.http('${env_url}', '/finalizar_chamada/$id_turma');

    Map data = {
      '': '',
    };
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    if (response.statusCode == 200) {
      _showSuccessDialog(context, "Chamada finalizada!");
    }
    else{
      _showFailDialog(context, "Ocorreu um erro. Tente novamente!");
    }

    List<dynamic> responseData = json.decode(response.body);
    
    return responseData;
    }
    else{
      _showFailDialog(context, "Não existe chamada em aberto para finzalizar!");
    }
    return responseData2;
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
              title: buildText(text: '${disciplina}: ${codTurma}', fontSize: 20, color: Colors.white, isBold: false),
              backgroundColor: Color(0xFF005AAA),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 90.0),
                buildInkWellWithIcon(Icons.menu_book,"Iniciar chamada",() {_iniciarChamada(context);},),
                buildInkWellWithIcon(Icons.emoji_flags,"Finalizar chamada",() {_finalizarChamada(context);},),
                buildInkWellWithIcon(Icons.remove_red_eye_outlined,"Visualizar chamada",() {Navigator.push(context,MaterialPageRoute(
                  builder: (context) => VisualizarProf(
                    turmaChamada: disciplina.toUpperCase(),
                    codTurma: codTurma.toUpperCase(),
                    id_turma: id_turma,
                    id_professor: id_professor,
                  ),
                ),);},),
                buildInkWellWithIcon(Icons.timer_sharp,"Agendar chamada",() {Navigator.push(context,MaterialPageRoute(
                  builder: (context) => AgendarProfScreen(
                          id_professor: id_professor,
                        ),
                ),);},),
                buildInkWellWithIcon(Icons.history,"Histórico de chamadas",() {Navigator.push(context,MaterialPageRoute(
                  builder: (context) => HistoricoProfessor(
                    turmaChamada: disciplina,
                    codTurma: codTurma,
                    id_professor: id_professor,
                    id_turma: id_turma,
                  ),
                ),);},),
                buildInkWellWithIcon(Icons.query_stats,"Estatísticas da Turma",() {Navigator.push(context,MaterialPageRoute(
                  builder: (context) => Estatisticas(
                    turmaChamada: disciplina,
                    codTurma: codTurma,
                    id_professor: id_professor,
                    id_turma: id_turma,
                  ),
                ),);},),
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

Widget _buildRowWithIconAndText(IconData iconName, String text) {
  return Row(
    children: [
      SizedBox(width: 60),
      Icon(iconName, color: Colors.black, size: 40),
      SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
    ],
  );
}

void _showSuccessDialog(BuildContext context, String texto) {
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

void _showFailDialog(BuildContext context, String texto) {
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

Widget buildInkWellWithIcon(
  IconData icon,
  String text,
  VoidCallback onTapAction,
) {
  return Column(
    children: [
      InkWell(
        onTap: onTapAction,
        child: _buildRowWithIconAndText(icon, text),
      ),
      SizedBox(height: 40.0),
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