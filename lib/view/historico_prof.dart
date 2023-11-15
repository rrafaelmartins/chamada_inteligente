import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricoProfessorPage extends StatelessWidget {
  Future<String?> getUserNameFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("userName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico do Professor'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Universidade Federal Fluminense'),
                  Text('Texto de rascunho 2'),
                  Text('Texto de rascunho 3'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('Texto de rascunho 4'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(child: Center(child: Text('Coluna 1'))),
                      TableCell(child: Center(child: Text('Coluna 2'))),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Center(child: Text('Exemplo 1-1'))),
                      TableCell(child: Center(child: Text('Exemplo 1-2'))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
