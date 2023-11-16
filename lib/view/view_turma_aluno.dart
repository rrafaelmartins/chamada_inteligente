import 'dart:convert';

import 'package:chamada_inteligente/view/historico_aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ViewTurmaAluno extends StatefulWidget {
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_aluno;

  ViewTurmaAluno({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_aluno});

  @override
  State<ViewTurmaAluno> createState() => _ViewTurmaAlunoState(disciplina: disciplina, codTurma: codTurma, id_turma: id_turma, id_aluno: id_aluno);
}

class _ViewTurmaAlunoState extends State<ViewTurmaAluno> {
  bool isSwitched = false; // Estado do Switch
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_aluno;
  String localizacao = "";
  var env_url = dotenv.env['URL'];

  Future<List<dynamic>> get_localizacao_chamada() async {
    
    var url = Uri.http('${env_url}', '/get_localizacao_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    print(responseData);
    if (responseData.length > 0){
      localizacao = responseData[0][0];
    }

    return responseData;
  }
  

  _ViewTurmaAlunoState({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_aluno});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${disciplina}: ${codTurma}'),
        backgroundColor: Color(0xFF005AAA),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.asset('images/confirmar.png'), // Imagem 1
 

                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  get_localizacao_chamada();
                },
                child: _buildRowWithIconAndText(Icons.check, "Confirmar Presença"),
              ), // Espaço entre a primeira e a segunda imagem

              SizedBox(height: 50), // Adicionei o InkWell aqui
              _buildRowWithIconAndText(Icons.cell_tower, "Presença Automática"), 

            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value; // Atualiza o estado do switch
                });
              },
            ),
            SizedBox(height: 50),
            InkWell( // Adicionei o InkWell aqui
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoricoAluno(turmaChamada: disciplina.toUpperCase(), codTurma: codTurma.toUpperCase(), id_turma: id_turma, id_aluno: id_aluno)),
                );
              },
              child: _buildRowWithIconAndText(Icons.access_time, "Histórico de chamadas"),
            ),             
            ],
          ),
        ),
    );
  }

  Widget _buildRowWithIconAndText(IconData iconName, String text) {
    return Row(
      children: [
        SizedBox(width: 60), // Espaço à esquerda para deslocar
        Icon(iconName, color: Colors.black, size: 40),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 24.0),
        ),
      ],
    );
  }
}