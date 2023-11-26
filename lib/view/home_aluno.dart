import 'dart:convert';
import 'package:chamada_inteligente/view/view_turma_aluno.dart';
import 'package:chamada_inteligente/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeAluno extends StatefulWidget {
  static String routeName = "/homealuno";
  final int id_aluno;
  HomeAluno({required this.id_aluno});

  @override
  State<HomeAluno> createState() => _HomeAlunoState(id_aluno: id_aluno);
}

class _HomeAlunoState extends State<HomeAluno> {
  bool ? isSwitched;
  final int id_aluno;
  _HomeAlunoState({required this.id_aluno});
  var env_url = dotenv.env['URL'];

  List<dynamic> turmasBD = [];
  String nome_aluno = "";
  String matricula_aluno = "";
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

  Future<List<dynamic>> get_localizacao_chamada() async {

    var url9 = Uri.http('${env_url}', '/get_switch/$id_aluno');
    var response9 = await http.get(url9);
    List<dynamic> responseData9 = json.decode(response9.body);
    if (responseData9[0][0] == 1){
      isSwitched = true;
    }
    else{
      isSwitched = false;
    }

    var url5 = Uri.http('${env_url}', '/check_open_chamadas_home/$id_aluno');
    var response5 = await http.get(url5);
    List<dynamic> responseData5 = json.decode(response5.body);
    
    var url = Uri.http('${env_url}', '/get_localizacao_chamada/${responseData5[0][0]}');
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

    var url5 = Uri.http('${env_url}', '/check_open_chamadas_home/$id_aluno');
    var response5 = await http.get(url5);
    List<dynamic> responseData5 = json.decode(response5.body);
    bool flag2 = true;

    var url = Uri.http('${env_url}', '/get_localizacao_chamada/${responseData5[0][0]}');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    if (responseData.length > 0){
      localizacao_chamada = responseData[0][0];
      
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
  
  Future<List<dynamic>> _getTurmas() async {
    var url = Uri.http('${env_url}', '/get_turmas_aluno/$id_aluno');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);

    for (var turma in responseData) {
      List temp = [];
      temp.add(turma[0]);
      temp.add(turma[1]);
      temp.add(turma[2]);
      turmasBD.add(temp);
    }
    
    var url2 = Uri.http('${env_url}', '/get_nome_matricula_aluno/$id_aluno');
    var response2 = await http.get(url2);
    List<dynamic> responseData2 = json.decode(response2.body);
    nome_aluno = responseData2[0][0];
    matricula_aluno = "${responseData2[0][1]}";

    var url10 = Uri.http('${env_url}', '/get_nome_matricula_aluno/$id_aluno');
    var response10 = await http.get(url10);
    List<dynamic> responseData10 = json.decode(response2.body);


    var url9 = Uri.http('${env_url}', '/get_switch/$id_aluno');
    var response9 = await http.get(url9);
    List<dynamic> responseData9 = json.decode(response9.body);
    if (responseData9[0][0] == 1){
      isSwitched = true;
    }
    else{
      isSwitched = false;
    }

    var url5 = Uri.http('${env_url}', '/check_open_chamadas_home/$id_aluno');
    var response5 = await http.get(url5);
    List<dynamic> responseData5 = json.decode(response5.body);

    List<dynamic> responseData44 = responseData;
    if (responseData5.isNotEmpty){
      var url44 = Uri.http('${env_url}', '/verificar_presenca/$id_aluno/${responseData5[0][0]}');
      var response44 = await http.get(url44);
      responseData44 = json.decode(response44.body);
    }

    if (responseData5.isNotEmpty && isSwitched == false && responseData44[0][0] == 0){
      String nometurma = responseData5[0][1];
      _showChamadaDialog(context, "Existe uma chamada em aberto de: ${nometurma}!");
    }

    else if (responseData5.isNotEmpty && isSwitched == true){
      if (responseData44[0][0] == 1){
        return responseData;
      }

       bool flagCreateArea = await _createAreaChamada(_centerChamada);

       if (flagCreateArea == true){
          if (await _isAlunoInArea(_centerChamada2!)) {
            var url = Uri.http('${env_url}', '/confirmar_presenca/$id_aluno/${responseData5[0][0]}');
            Map data = {
                '': '',
            };
            var body = json.encode(data);

            var response = await http.post(url,
              headers: {"Content-Type": "application/json"},
              body: body,
            );
            if (response.statusCode == 200) {
              _showSuccessDialog(context,"Presença Confirmada!");
              return responseData;
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

    return responseData;
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _getTurmas(),
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
            turmasBD = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color(0xFF005AAA),
                leading: IconButton(
                  icon: Icon(Icons.logout, color: Colors.white, size: 40),
                  onPressed: () {
                    _logout(context);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, color: Colors.white, size: 30),
                    SizedBox(width: 10),                 
                    Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: buildText(text: 'Turmas', fontSize: 20, color: Colors.white, isBold: false),
                    ),
                  ],
                ), 
              ),
              body: ListView.builder(
                itemCount: turmasBD.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFFFbbc4e3),
                    child: ListTile(
                      title: buildText(text: '${turmasBD[index][0]}', fontSize: 16, color: Colors.black, isBold: true),
                      subtitle: buildText(text: 'Turma: ${turmasBD[index][1]}', fontSize: 16, color: Colors.black, isBold: false),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              ViewTurmaAluno(disciplina: turmasBD[index][0]!, codTurma: turmasBD[index][1]!, id_turma: turmasBD[index][2]!, id_aluno: id_aluno, nome_aluno: nome_aluno, matricula_aluno: matricula_aluno, isSwitched: isSwitched!),
                          ),
                        );
                      },
                    ),
                  );
                },
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

void _logout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => LoginPage(),
    ),
    (route) => false,
  );
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

void _showChamadaDialog(BuildContext context, String texto) {
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