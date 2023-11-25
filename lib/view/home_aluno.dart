import 'dart:convert';

import 'package:chamada_inteligente/view/view_turma.dart';
import 'package:chamada_inteligente/view/view_turma_aluno.dart';
import 'package:chamada_inteligente/view/login.dart';
import 'package:flutter/material.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
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

  Future<List<dynamic>> get_localizacao_chamada() async {

      //get switch value
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
    timestamp: DateTime.now(), // Definido para o momento atual
    accuracy: 0, // Defina valores padrão ou obtenha-os de alguma forma
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
    print(responseData5);
  

    if (responseData5.isNotEmpty && isSwitched == false){
      String nometurma = responseData5[0][1];
      _showChamadaDialog(context, Text("Existe uma chamada em aberto de: ${nometurma}!"));
    }

    else if (responseData5.isNotEmpty && isSwitched == true){
      var url2 = Uri.http('${env_url}', '/verificar_presenca/$id_aluno/${responseData5[0][0]}');
      var response2 = await http.get(url2);
      List<dynamic> responseData2 = json.decode(response2.body);

      if (responseData2[0][0] == 1){
        _showFailDialog(context, Text("Você já marcou presença."));
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
              _showSuccessDialog(context); // Chamando o diálogo de sucesso
            }
            else{
              _showFailDialog(context, Text("Ocorreu um erro. Tente novamente"));
            }
          }
          else{
            _showFailDialog(context, Text("Você não está na área da chamada. Tente novamente.")); //MUDAR PARA DIALOGBOX
          }
        }
        else{
          _showFailDialog(context, Text("Ocorreu um erro.")); //MUDAR PARA DIALOGBOX
        }
      //registrar chamada
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
                    padding: EdgeInsets.only(right: 60), // Adiciona margem à esquerda do texto
                    child: Text(
                      'Turmas',
                      style: TextStyle(color: Colors.white),
                    ),
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
                    title: Text(
                      '${turmasBD[index][0]}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Turma: ${turmasBD[index][1]}',
                      style: TextStyle(color: Colors.black),
                    ),
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
                    Text(
                      'Aluno: ${nome_aluno}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Matrícula: ${matricula_aluno}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
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
}

  void _showChamadaDialog(BuildContext context, Text texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chamada"),
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