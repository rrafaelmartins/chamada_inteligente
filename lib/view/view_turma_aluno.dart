import 'package:flutter/material.dart';

class ViewTurmaAluno extends StatefulWidget {
  final String disciplina;
  final String codTurma;

  ViewTurmaAluno({required this.disciplina, required this.codTurma});

  @override
  State<ViewTurmaAluno> createState() => _ViewTurmaAlunoState(disciplina: disciplina, codTurma: codTurma);
}

class _ViewTurmaAlunoState extends State<ViewTurmaAluno> {
  bool isSwitched = false; // Estado do Switch
  final String disciplina;
  final String codTurma;
  _ViewTurmaAlunoState({required this.disciplina, required this.codTurma});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${disciplina}: ${codTurma}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/confirmar.png'), // Imagem 1
            SizedBox(height: 20), // Espaço entre a primeira e a segunda imagem

            Image.asset('images/presenca.png'), // Imagem 2
            SizedBox(height: 20), // Espaço entre a segunda imagem e o switch

            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value; // Atualiza o estado do switch
                });
              },
            ),

            SizedBox(height: 20), // Espaço entre o switch e a terceira imagem

            Image.asset('images/historico.png'), // Imagem 3
          ],
        ),
      ),
    );
  }
}
