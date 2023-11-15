import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisualizarProf extends StatelessWidget {
  final String turmaChamada;
  final String codTurma;
  var date = DateFormat.yMMMEd().format(DateTime.now());

  VisualizarProf({required this.turmaChamada, required this.codTurma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Prof', style: TextStyle(color: ThemeColors.text)),
        backgroundColor: ThemeColors.appBar,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('PROFESSOR: LEONARDO MURTA', style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('DISCIPLINA: ' + turmaChamada, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('TURMA: ' + codTurma, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),
              Text('Data: ' + date, style: TextStyle(fontSize: 14, color: ThemeColors.text)),
              SizedBox(height: 10),

              // Tabela de chamada
              Table(
                border: TableBorder.all(color: Colors.grey, width: 1.0),
                children: const [
                  // Headers da tabela
                  TableRow(children: [
                    Text('NOME', textAlign: TextAlign.center),
                    Text('MATRÍCULA', textAlign: TextAlign.center),
                    Text('PRESENÇA', textAlign: TextAlign.center),
                    Text('JUSTIFICAR FALTA', textAlign: TextAlign.center),
                  ]),

                  // Adicione mais TableRow para cada aluno
                  // Exemplo:
                  TableRow(children: [
                    Text('ANGELO', textAlign: TextAlign.center),
                    Text('123456789', textAlign: TextAlign.center),
                    Icon(Icons.close, color: Colors.red), // Use Icons.check para presença; Aqui ocorrerá a chamada ao BD
                    Text('', textAlign: TextAlign.center), // Deixe em branco se não houver justificativa
                  ]),
                  TableRow(children: [
                    Text('MATEUS FERREIRA', textAlign: TextAlign.center),
                    Text('123456789', textAlign: TextAlign.center),
                    Icon(Icons.close, color: Colors.red), // Use Icons.check para presença; Aqui ocorrerá a chamada ao BD
                    Text('', textAlign: TextAlign.center), // Deixe em branco se não houver justificativa
                  ]),
                  TableRow(children: [
                    Text('LUCAS PACHECO', textAlign: TextAlign.center),
                    Text('123456789', textAlign: TextAlign.center),
                    Icon(Icons.close, color: Colors.red), // Use Icons.check para presença; Aqui ocorrerá a chamada ao BD
                    Text('', textAlign: TextAlign.center), // Deixe em branco se não houver justificativa
                  ]),
                  TableRow(children: [
                    Text('RAFAEL AGUIAR MARTINS', textAlign: TextAlign.center),
                    Text('123456789', textAlign: TextAlign.center),
                    Icon(Icons.close, color: Colors.red), // Use Icons.check para presença; Aqui ocorrerá a chamada ao BD
                    Text('', textAlign: TextAlign.center), // Deixe em branco se não houver justificativa
                  ]),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
