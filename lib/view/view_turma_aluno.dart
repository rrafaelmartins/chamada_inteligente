import 'package:chamada_inteligente/view/historico_aluno.dart';
import 'package:flutter/material.dart';

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
          children: [
            Image.asset('images/confirmar.png'), // Imagem 1
            SizedBox(height: 50), // Espaço entre a primeira e a segunda imagem

            Image.asset('images/presenca.png'), // Imagem 2

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
              child: _buildRowWithIconAndText('relogio.png', "Histórico de chamadas"),
            ),             
            ],
          ),
        ),
    );
  }

  Widget _buildRowWithIconAndText(String iconName, String text) {
    return Row(
      children: [
        SizedBox(width: 60), // Espaço à esquerda para deslocar
        Image.asset(
          'images/$iconName',
          width: 50,
          height: 50,
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