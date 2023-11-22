import 'dart:convert';
import 'package:chamada_inteligente/view/agendar_prof.dart';
import 'package:chamada_inteligente/view/historico_prof.dart';
import 'package:chamada_inteligente/view/visualizar_chamada_prof.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class TurmaPage extends StatelessWidget {
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  String ?localizacao;
  var env_url = dotenv.env['URL'];

  TurmaPage({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_professor});


  Future<Map<String, dynamic>> _iniciarChamada(BuildContext context) async {
    var url = Uri.http('${env_url}', '/iniciar_chamada/${id_turma}/');

    await Geolocator.requestPermission();
    await Geolocator.checkPermission();

      Position prof_position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);


    localizacao = '${prof_position.latitude},${prof_position.longitude}';

    Map data = {
      'localizacao': localizacao,
    };
    var body = json.encode(data);
  print(url);
  var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    if (response.statusCode == 200) {
      _showSuccessDialog(context); // Chamando o diálogo de sucesso
    }
    else{
      _showFailDialog(context);
    }

    Map<String, dynamic> responseData = json.decode(response.body);
    
    return responseData;
    
  }


  Future<List<dynamic>> _finalizarChamada(BuildContext context) async {
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
      _showSuccessDialog(context); // Chamando o diálogo de sucesso
    }
    else{
      _showFailDialog(context);
    }

    List<dynamic> responseData = json.decode(response.body);
    
    return responseData;
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sucesso"),
          content: Text("A requisição foi feita com sucesso!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

    void _showFailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text("Tente novamente"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${disciplina}: ${codTurma}'),
        backgroundColor: Color(0xFF005AAA),
        centerTitle: true,
      ),
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 90.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  _iniciarChamada(context);
                },
                child: _buildRowWithIconAndText('lista.png', "Iniciar chamada"),
              ),
              
              SizedBox(height: 40.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  _finalizarChamada(context);
                },
                child: _buildRowWithIconAndText('bandeira.png', "Finalizar chamada"),
              ),
              
              SizedBox(height: 40.0),
              InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisualizarProf(turmaChamada: disciplina.toUpperCase(), codTurma: codTurma.toUpperCase(), id_turma: id_turma, id_professor: this.id_professor)),
                  );
                },
                child: _buildRowWithIconAndText('olho.png', "Visualizar chamada"),
              ),
              SizedBox(height: 40.0),
              InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgendarProfScreen()),
                  );
                },
                child: _buildRowWithIconAndText('agenda.png', "Agendar chamada"),
              ),
              SizedBox(height: 40.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoricoProfessor(turmaChamada: disciplina, codTurma: codTurma, id_professor: id_professor, id_turma: id_turma)),
                  );
                },
                child: _buildRowWithIconAndText('relogio.png', "Histórico de chamadas"),
              ),
            ],
          ),
    );
  }

  Widget _buildRowWithIconAndText(String iconName, String text) {
    return Row(
      children: [
        SizedBox(width: 70), // Espaço à esquerda para deslocar
        Image.asset(
          'images/$iconName',
          width: 40,
          height: 40,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 24.0),
        ),
      ],
    );
  }
}
