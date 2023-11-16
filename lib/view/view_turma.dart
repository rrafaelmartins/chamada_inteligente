import 'package:chamada_inteligente/view/agendar_prof.dart';
import 'package:chamada_inteligente/view/historico_prof.dart';
import 'package:chamada_inteligente/view/visualizar_chamada_prof.dart';
import 'package:flutter/material.dart';


class TurmaPage extends StatelessWidget {
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_professor;

  TurmaPage({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_professor});

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
              _buildRowWithIconAndText('lista.png', "Iniciar chamada"),
              SizedBox(height: 40.0),
              _buildRowWithIconAndText('bandeira.png', "Finalizar chamada"),
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
                    MaterialPageRoute(builder: (context) => HistoricoProfessor(turmaChamada: disciplina, codTurma: codTurma, id_professor: id_professor,)),
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
