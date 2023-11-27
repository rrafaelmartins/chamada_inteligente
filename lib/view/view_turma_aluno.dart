import 'dart:convert';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:chamada_inteligente/view/historico_aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ViewTurmaAluno extends StatefulWidget {
  final String disciplina;
  final String codTurma;
  final String matricula_aluno;
  final String nome_aluno;
  final int id_turma;
  final int id_aluno;
  final bool isSwitched;

  ViewTurmaAluno({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_aluno, required this.nome_aluno, required this.matricula_aluno, required this.isSwitched});

  @override
  State<ViewTurmaAluno> createState() => _ViewTurmaAlunoState(disciplina: disciplina, codTurma: codTurma, id_turma: id_turma, id_aluno: id_aluno, nome_aluno: nome_aluno, matricula_aluno: matricula_aluno);
}

class _ViewTurmaAlunoState extends State<ViewTurmaAluno> {
  _ViewTurmaAlunoState({required this.disciplina, required this.codTurma, required this.id_turma, required this.id_aluno, required this.nome_aluno, required this.matricula_aluno});
  bool isSwitched2= false;
  final String disciplina;
  final String codTurma;
  final int id_turma;
  final int id_aluno;
  final String matricula_aluno;
  final String nome_aluno;
  String localizacao_chamada = "";
  double ?latitude;
  double ?longitude;
  String _message = '';
  Position _centerChamada = Position(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
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

  Future<List<dynamic>> get_switch() async {
    var url9 = Uri.http('${env_url}', '/get_switch/$id_aluno');
    var response9 = await http.get(url9);
    List<dynamic> responseData9 = json.decode(response9.body);
    if (responseData9[0][0] == 1){
      isSwitched2 = true;
    }
    else{
      isSwitched2 = false;
    }
    return responseData9;
  }

  void update_switch() async {

    var url = Uri.http('${env_url}', '/update_switch/$id_aluno');
    var response = await http.put(url);
  }

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

    print("--------------------");
    print(_centerChamada.latitude);
    print(_centerChamada.longitude);
    print("--------------------");
    print(aluno_position.latitude);
    print(aluno_position.longitude);

      if (distanceInMeters <= 5) {
        isInArea = true;
      } else {
        isInArea = false;
      }

    return isInArea;
  }
  
  Future<List<dynamic>> confirmar_presenca(BuildContext context, Position _centerChamada) async {
    var url = Uri.http('${env_url}', '/check_open_chamadas/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    if (responseData[0][0] == 1){
      var url2 = Uri.http('${env_url}', '/verificar_presenca/$id_aluno/$id_turma');
      var response2 = await http.get(url2);
      List<dynamic> responseData2 = json.decode(response2.body);

      if (responseData2[0][0] == 1){
        _showFailDialog(context, "Você já marcou presença!");
        return responseData2;
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
            _showSuccessDialog(context, "Presença Confirmada!");
          }
          else{
            _showFailDialog(context, "Ocorreu um erro. Tente novamente!");
          }
        }
        else{
          _showFailDialog(context, "Você não está na área da chamada. Tente novamente!");
        }
      }
      else{
        _showFailDialog(context, "Ocorreu um erro!");
      }
      }
      else{
        _showFailDialog(context, "Não existe chamada aberta dessa turma!");
    }

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: get_switch(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF005AAA),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            return Scaffold(
              backgroundColor: ThemeColors.background,
              appBar: AppBar(
                title: buildText(text: '${disciplina}', fontSize: 20, color: Colors.white, isBold: false),
                backgroundColor: Color(0xFF005AAA),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        confirmar_presenca(context, _centerChamada!);
                      },
                      child: _buildRowWithIconAndText(Icons.check, "Confirmar Presença"),
                    ),
                    SizedBox(height: 50),
                    _buildRowWithIconAndText(Icons.cell_tower, "Presença Automática"),
                    Switch(
                      value: isSwitched2,
                      onChanged: (value) {
                        setState(() {
                          update_switch();
                          isSwitched2 = value;
                        });
                      },
                    ),
                    SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoricoAluno(
                              turmaChamada: disciplina.toUpperCase(),
                              codTurma: codTurma.toUpperCase(),
                              id_turma: id_turma,
                              id_aluno: id_aluno,
                              nome_aluno: nome_aluno,
                              matricula_aluno: matricula_aluno,
                            ),
                          ),
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
                      buildText(text: 'Aluno: ${nome_aluno}', fontSize: 16, color: Colors.white, isBold: false),
                      buildText(text: 'Matrícula: ${matricula_aluno}', fontSize: 16, color: Colors.white, isBold: false),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}

void _showSuccessDialog(BuildContext context, String texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: null,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            texto,
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text("OK",style: TextStyle(color: Color(0xFF005AAA)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

void _showFailDialog(BuildContext context, String texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: null,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            texto,
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text("OK",style: TextStyle(color: Color(0xFF005AAA)),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildRowWithIconAndText(IconData iconName, String text) {
  return Row(
    children: [
      SizedBox(width: 60),
      Icon(iconName, color: Colors.black, size: 40),
      SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
    ],
  );
}

Widget buildText({
  required String text,
  double fontSize = 14,
  Color color = Colors.black,
  bool isBold = false,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}