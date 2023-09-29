import 'package:flutter/material.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';

class HomeProfessor extends StatefulWidget {
  static String routeName = "/homeprofessor";
  const HomeProfessor({super.key});

  @override
  State<HomeProfessor> createState() => _HomeProfessorState();
}

class _HomeProfessorState extends State<HomeProfessor> {
  // Lista de turmas para demonstração
  final List<Map<String, String>> turmas = [
    {
      'codigo': 'TCC00293 - Engenharia de Software II',
      'nome': 'Engenharia de Software II',
      'turma': 'Turma A1 - 2023.2'
    },
    {
      'codigo': 'TCC00339',
      'nome': 'Gerência de Projetos e Manutenção de Software',
      'turma': 'Turma A1 - 2023.2'
    }
    // ... Adicione mais turmas conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        backgroundColor: ThemeColors.grey,
        leading: IconButton(
          icon: Image.asset('images/logout.png'),
          onPressed: () {
            // Implemente a ação de logout aqui
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/chapeu.png', width: 30),
            SizedBox(width: 10),
            Text('Turmas', style: TextStyle(color: ThemeColors.text)),
          ],
        ),
        
      ),
      body: ListView.builder(
        itemCount: turmas.length,
        itemBuilder: (context, index) {
          return Card(
            color: ThemeColors.formInput,
            child: ListTile(
              title: Text('${turmas[index]['codigo']}: ${turmas[index]['nome']}', style: TextStyle(color: ThemeColors.text)),
              subtitle: Text(turmas[index]['turma']!, style: TextStyle(color: ThemeColors.grey)),
              onTap: () {
                // Implemente a navegação para a tela de detalhes da turma aqui
              },
            ),
          );
        },
      ),
    );
  }
}