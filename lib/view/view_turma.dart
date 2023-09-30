import 'package:flutter/material.dart';

class TurmaPage extends StatelessWidget {
  final String nomeTurma;

  TurmaPage({required this.nomeTurma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeTurma),
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
              _buildRowWithIconAndText('olho.png', "Visualizar chamada"),
              SizedBox(height: 50.0),
              _buildRowWithIconAndText('agenda.png', "Agendar chamada"),
              SizedBox(height: 50.0),
              _buildRowWithIconAndText('relogio.png', "Histórico de chamadas"),
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
