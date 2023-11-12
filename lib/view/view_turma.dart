import 'package:chamada_inteligente/view/agendar_prof.dart';
import 'package:chamada_inteligente/view/historico_prof.dart';
import 'package:chamada_inteligente/view/visualizar_chamada_prof.dart';
import 'package:flutter/material.dart';

class TurmaPage extends StatelessWidget {
  final String disciplina;
  final String codTurma;

  TurmaPage({required this.disciplina, required this.codTurma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disciplina),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50.0),
              _buildRowWithIconAndText('lista.png', "Iniciar chamada"),
              SizedBox(height: 50.0),
              _buildRowWithIconAndText('bandeira.png', "Finalizar chamada"),
              SizedBox(height: 50.0),
              InkWell(
                // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisualizarProf(
                              turmaChamada: disciplina.toUpperCase(),
                              codTurma: codTurma.toUpperCase(),
                            )),
                  );
                },
                child:
                    _buildRowWithIconAndText('olho.png', "Visualizar chamada"),
              ),
              SizedBox(height: 50.0),
              InkWell(
                // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgendarProfScreen()),
                  );
                },
                child:
                    _buildRowWithIconAndText('agenda.png', "Agendar chamada"),
              ),
              SizedBox(height: 50.0),
              InkWell(
                // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoricoProfessorPage()),
                  );
                },
                child: _buildRowWithIconAndText(
                    'relogio.png', "Historico de Chamadas"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowWithIconAndText(String iconName, String text) {
    return Row(
      children: [
        SizedBox(width: 20), // Espaço à esquerda para deslocar
        Image.asset(
          'images/$iconName',
          width: 30,
          height: 30,
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
