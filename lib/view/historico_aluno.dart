import 'package:flutter/material.dart';

class HistoricoAlunoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico do Aluno'),
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
                  Text('Texto de rascunho 1'),
                  Text('Texto de rascunho 2'),
                  Text('Texto de rascunho 3'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Texto lado a lado 1'),
                  ),
                  Expanded(
                    child: Text('Texto lado a lado 2'),
                  ),
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
                      TableCell(child: Center(child: Text('Coluna 3'))),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Center(child: Text('Exemplo 1-1'))),
                      TableCell(child: Center(child: Text('Exemplo 1-2'))),
                      TableCell(child: Center(child: Text('Exemplo 1-3'))),
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
