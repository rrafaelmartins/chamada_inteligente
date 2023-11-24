import 'dart:convert';
import 'package:chamada_inteligente/view/historico_aluno.dart';
import 'package:chamada_inteligente/view/view_turma.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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
  String localizacao_chamada = "";
  double ?latitude;
  double ?longitude;
  String _message = '';
  Position _centerChamada = Position(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(), // Definido para o momento atual
    accuracy: 0, // Defina valores padrão ou obtenha-os de alguma forma
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
  Position? _centerChamada2;
  Position? aluno_position;
  var env_url = dotenv.env['URL'];

  String nome_aluno = "";
  String matricula_aluno = "";

  Future<List<dynamic>> get_localizacao_chamada() async {
    
    var url = Uri.http('${env_url}', '/get_localizacao_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    if (responseData.length > 0){
      setState(() {
        localizacao_chamada = responseData[0][0];
      });
      var parts = localizacao_chamada.split(',');
      latitude = double.parse(parts[0]);
      longitude = double.parse(parts[1]);
    }
 
    return responseData;
  }

  Future<bool> _createAreaChamada(Position _centerChamada) async {
    bool flag2 = true;
    var url = Uri.http('${env_url}', '/get_localizacao_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    if (responseData.length > 0){
      setState(() {
        localizacao_chamada = responseData[0][0];
      });
      var parts = localizacao_chamada.split(',');
      latitude = double.parse(parts[0]);
      longitude = double.parse(parts[1]);
    }
    _centerChamada = Position(
    latitude: latitude!,
    longitude: longitude!,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    );

    _centerChamada2 = _centerChamada;
    
    return flag2;
  }
  

  Future<bool> _isAlunoInArea(Position _centerChamada) async {
      bool isInArea;

      await Geolocator.requestPermission();
      await Geolocator.checkPermission();

      Position aluno_position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distanceInMeters = Geolocator.distanceBetween(
        _centerChamada.latitude,
        _centerChamada.longitude,
        aluno_position.latitude,
        aluno_position.longitude,
      );

      if (distanceInMeters <= 5) {
        isInArea = true;
      } else {
        isInArea = false;
      }
      
      return isInArea;
    }
  
  Future<List<dynamic>> confirmar_presenca(BuildContext context, Position _centerChamada) async {

    //consulta: existe chamada aberta dessa turma?
    var url = Uri.http('${env_url}', '/check_open_chamadas/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    if (responseData[0][0] == 1){
      //consulta: esse aluno já confirmou presenca?
      var url2 = Uri.http('${env_url}', '/verificar_presenca/$id_aluno/$id_turma');
      var response2 = await http.get(url2);
      List<dynamic> responseData2 = json.decode(response2.body);

      if (responseData2[0][0] == 1){
        _showFailDialog(context, Text("Você já marcou presença."));
        return responseData;
      }

      bool flagCreateArea = await _createAreaChamada(_centerChamada);
      if (flagCreateArea == true){
        if (await _isAlunoInArea(_centerChamada2!)) {
          var url = Uri.http('${env_url}', '/confirmar_presenca/$id_aluno/$id_turma');
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
        }
        else{
          print("else");
          _showFailDialog(context, Text("Você não está na área da chamada. Tente novamente.")); //MUDAR PARA DIALOGBOX
        }
      }
      else{
        _showFailDialog(context, Text("Ocorreu um erro.")); //MUDAR PARA DIALOGBOX
      }
    }

    return responseData;
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
          children: <Widget>[ 
            InkWell( // Adicionei o InkWell aqui
              onTap: () {
                confirmar_presenca(context, _centerChamada!);
              },
              child: _buildRowWithIconAndText(Icons.check, "Confirmar Presença"),
            ), // Espaço entre a primeira e a segunda imagem

            SizedBox(height: 50), // Adicionei o InkWell aqui
            _buildRowWithIconAndText(Icons.cell_tower, "Presença Automática"), 

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
              child: _buildRowWithIconAndText(Icons.access_time, "Histórico de chamadas"),
            ),             
          ],
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Color(0xFF005AAA),
          height: 30.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Aluno: ${nome_aluno}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
              Text('Matrícula: ${matricula_aluno}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
            ],
          ),
        ),
      ),
    );
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