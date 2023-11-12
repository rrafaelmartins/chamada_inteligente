import 'package:flutter/material.dart';
import 'historico_aluno.dart'; // Importe o arquivo da página do histórico do aluno

class ViewTurmaAluno extends StatefulWidget {
  final String nomeTurma;

  ViewTurmaAluno({required this.nomeTurma});

  @override
  State<ViewTurmaAluno> createState() => _ViewTurmaAlunoState();
}

class _ViewTurmaAlunoState extends State<ViewTurmaAluno> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeTurma),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Espaço entre as imagens

            Image.asset('images/confirmar.png'), // Imagem 1
            SizedBox(height: 20), // Espaço entre a primeira e a segunda imagem

            Image.asset('images/presenca.png'),
            GestureDetector(
              onTap: () {
                // Navega para a página de histórico do aluno ao clicar na imagem
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoricoAlunoPage()),
                );
              },
              child:
                  Image.asset('images/historico.png'), // Imagem 3 (Histórico)
            )
          ],
        ),
      ),
    );
  }
}
