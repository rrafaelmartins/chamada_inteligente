import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:chamada_inteligente/view/agendar_prof.dart';
import 'package:chamada_inteligente/view/historico_prof.dart';
import 'package:chamada_inteligente/view/visualizar_chamada_prof.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class TurmaPage extends StatelessWidget {
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_professor;
  String ?localizacao;
  String nome_professor = "";
  String matricula_professor = "";
  var env_url = dotenv.env['URL'];

  TurmaPage({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_professor});



  Future<List<dynamic>> get_nome_matricula_professor() async {
  
    
    var url8 = Uri.http('${env_url}', '/get_nome_matricula_professor/$id_professor');
    var response8 = await http.get(url8);
    List<dynamic> responseData8 = json.decode(response8.body);
    nome_professor = responseData8[0][0];
    matricula_professor = "${responseData8[0][1]}";

    return responseData8;
  }


  Future<Map<String, dynamic>> _iniciarChamada(BuildContext context) async {


    print("ENTROU NESSA PORRA");
    var url2 = Uri.http('${env_url}', '/check_open_chamadas/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    print("responseData: ");
    print(responseData2);

    

    if (responseData2[0][0] == 0){

    var url = Uri.http('${env_url}', '/iniciar_chamada/${id_turma}/');

    await Geolocator.requestPermission();
    await Geolocator.checkPermission();

      Position prof_position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);


    localizacao = '${prof_position.latitude},${prof_position.longitude}';

    Map data = {
      'localizacao': localizacao,
    };
    var body = json.encode(data);
    print(url);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    if (response.statusCode == 200) {
      _showSuccessDialog(context); // Chamando o diálogo de sucesso
    }
    else{
      _showFailDialog(context, Text("Ocorreu um erro. Tente novamente"));
    }

    Map<String, dynamic> responseData = json.decode(response.body);
    
    return responseData;
    }
    else{
      _showFailDialog(context, Text("Já existe uma chamada em aberto"));
    }
    
    return {'status': 'chamada_nao_iniciada', 'data': responseData2};
  }


  Future<List<dynamic>> _finalizarChamada(BuildContext context) async {

    print("ENTROU NESSA PORRA DE FINALIZAR");
    var url2 = Uri.http('${env_url}', '/check_open_chamadas/$id_turma');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    print("responseData: ");
    print(responseData2);


    if (responseData2[0][0] == 1){

    var url = Uri.http('${env_url}', '/finalizar_chamada/$id_turma');

    Map data = {
      '': '',
    };
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body,
    );

    if (response.statusCode == 200) {
      _showSuccessDialog(context); // Chamando o diálogo de sucesso
    }
    else{
      _showFailDialog(context, Text("Ocorreu um erro. Tente novamente"));
    }

    List<dynamic> responseData = json.decode(response.body);
    
    return responseData;
    }
    else{
      _showFailDialog(context, Text("Não existe chamada em aberto para fechar"));
    }
    return responseData2;
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sucesso"),
          content: Text("A requisição foi feita com sucesso!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

    void _showFailDialog(BuildContext context, Text texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: texto,
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
    future: get_nome_matricula_professor(),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          backgroundColor: ThemeColors.background,
          appBar: AppBar(
            backgroundColor: ThemeColors.grey,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text('Carregando...', style: TextStyle(color: ThemeColors.text)),
              ],
            ),
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(title: Text('${disciplina}: ${codTurma}'),
          backgroundColor: Color(0xFF005AAA),
          centerTitle: true,
      ),
      body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 90.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  _iniciarChamada(context);
                },
                child: _buildRowWithIconAndText(Icons.menu_book, "Iniciar chamada"),
              ),
              
              SizedBox(height: 40.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  _finalizarChamada(context);
                },
                child: _buildRowWithIconAndText(Icons.emoji_flags, "Finalizar chamada"),
              ),
              
              SizedBox(height: 40.0),
              InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisualizarProf(turmaChamada: disciplina.toUpperCase(), codTurma: codTurma.toUpperCase(), id_turma: id_turma, id_professor: this.id_professor)),
                  );
                },
                child: _buildRowWithIconAndText(Icons.remove_red_eye_outlined, "Visualizar chamada"),
              ),
              SizedBox(height: 40.0),
              InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgendarProfScreen(id_professor: id_professor)),
                  );
                },
                child: _buildRowWithIconAndText(Icons.timer_sharp, "Agendar chamada"),
              ),
              SizedBox(height: 40.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoricoProfessor(turmaChamada: disciplina, codTurma: codTurma, id_professor: id_professor, id_turma: id_turma)),
                  );
                },
                child: _buildRowWithIconAndText(Icons.history, "Histórico de chamadas"),
              ),
              SizedBox(height: 40.0),
                InkWell( // Adicionei o InkWell aqui
                onTap: () {
                  Navigator.push(
                    context,                                //chamar as estatisticas
                    MaterialPageRoute(builder: (context) => HistoricoProfessor(turmaChamada: disciplina, codTurma: codTurma, id_professor: id_professor, id_turma: id_turma)),
                  );
                },
                child: _buildRowWithIconAndText(Icons.query_stats, "Estatísticas da Turma"),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Color(0xFF005AAA),
          height: 30.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Professor: ${nome_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              Text('Matrícula: ${matricula_professor}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
            ],
          ),
        ),
      ),
    );
  }});
  }

  Widget _buildRowWithIconAndText(IconData iconName, String text) {
    return Row(
      children: [
        SizedBox(width: 60), // Espaço à esquerda para deslocar
        Icon(iconName, color: Colors.black, size: 40),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 24.0),
        ),
      ],
    );
  }
}