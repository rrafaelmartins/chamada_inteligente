//TO-D0: CONSEGUIR SINCRONIZAR BUILD.GRADLE COM O PROJETO; JÁ ESTÁ PEGANDO A LOCALIZACAO NORMAL, MAS NAO CONSEGUE PERMISSAO PARA PEGAR
//A LOCALIZCAO DO USUARIO
//https://stackoverflow.com/questions/65752257/flutter-geolocator-isnt-working-make-sure-at-least-access-fine-location-or-acc/65761663#65761663



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

  Future<List<dynamic>> get_localizacao_chamada() async {
    
    var url = Uri.http('${env_url}', '/get_localizacao_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    print("aqui: ");
    print(responseData);
    if (responseData.length > 0){
      
      setState(() {
        print("entrou no set state");
        localizacao_chamada = responseData[0][0];
      });

      var parts = localizacao_chamada.split(',');
      /*_center = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);*/

      latitude = double.parse(parts[0]);
      longitude = double.parse(parts[1]);

      print("latitude: " + "${latitude}" + " longitude: " + "${latitude}");
      /*print("entrou nesse if");
      print(responseData[0][0]);
      localizacao_chamada = responseData[0][0];*/
      print("localizacao_chamada recebeu: " + localizacao_chamada);

    }
    return responseData;
  }

  Future<bool> _createAreaChamada(Position _centerChamada) async {
    bool flag2 = true;
    print("entrou aqui blablabla");
    //print(localizacao_chamada + "<----");


    var url = Uri.http('${env_url}', '/get_localizacao_chamada/$id_turma');
    print("turma: ${id_turma}");
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);
    print("aqui: ");
    print(responseData);
    if (responseData.length > 0){
      
      setState(() {
        print("entrou no set state");
        localizacao_chamada = responseData[0][0];
      });

      var parts = localizacao_chamada.split(',');
      /*_center = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);*/

      latitude = double.parse(parts[0]);
      longitude = double.parse(parts[1]);

      print("latitude: " + "${latitude}" + " longitude: " + "${latitude}");
      /*print("entrou nesse if");
      print(responseData[0][0]);
      localizacao_chamada = responseData[0][0];*/
      print("localizacao_chamada recebeu: " + localizacao_chamada);

    }



    
      /*var parts = localizacao_chamada.split(',');
      /*_center = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);*/

      double latitude = double.parse(parts[0]);
      double longitude = double.parse(parts[1]);*/

    

    print("dentro de createArea");
    print(latitude);
    print(longitude);
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
  print("valor de centerChamada dentro de createArea: "+ "${_centerChamada}");

  _centerChamada2 = _centerChamada;

  print("centerChamada2: " + "${_centerChamada2}");

    return flag2;

  }
  

  Future<bool> _isAlunoInArea(Position _centerChamada) async {

      bool isInArea;

      
      await Geolocator.requestPermission();
      await Geolocator.checkPermission();

      Position aluno_position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      print("coordendas do professor: ${_centerChamada.latitude}, ${_centerChamada.longitude}");
      print("coordendas do aluno: ${aluno_position.latitude}, ${aluno_position.longitude}");

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
    print("responseData: ");
    print(responseData);

    if (responseData[0][0] == 1){
       bool flagCreateArea = await _createAreaChamada(_centerChamada);
       print("flagCreateArea valor: "+"$flagCreateArea");
       print("_centerChamada2 recebeu o seguinte: ");
       print(_centerChamada2);
       if (flagCreateArea == true){
          //bool isAlunoInArea = await _isAlunoInArea(_centerChamada2!);
          //print("esta é a flag de area: " + "${isAlunoInArea}");
          if (await _isAlunoInArea(_centerChamada2!)) {
              print("flag é true");
              var url = Uri.http('${env_url}', '/confirmar_presenca/$id_aluno/$id_turma');
              Map data = {
                  '': '',
              };
              var body = json.encode(data);

              var response = await http.post(url,
                headers: {"Content-Type": "application/json"},
                body: body,
              );
              //responseData = json.decode(response.body);
              print(response.statusCode);
                  if (response.statusCode == 200) {
                    _showSuccessDialog(context); // Chamando o diálogo de sucesso
                  }
                  else{
                    _showFailDialog(context);
                  }

          }
          else{
          print("else");
          _showFailDialog(context); //MUDAR PARA DIALOGBOX
        }
        }
        else{
          _showFailDialog(context); //MUDAR PARA DIALOGBOX
        }
       }
       

    //localizacao da chamada (latitude e longitude)
    //_createAreaChamada();
    //_centerChamada;


    //localizacao do aluno
    //aluno_position;

    //criar uma area em volta dessa localizacao da chamada

    //verificar se estou dentro da area
    //_isAlunoInArea(_centerChamada!);

    // 

    /*var url = Uri.http('${env_url}', '/get_localizacao_chamada/$id_turma');
    var response = await http.get(url);
    List<dynamic> responseData = json.decode(response.body);*/

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

    void _showFailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text("Tente novamente"),
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
            //Image.asset('images/confirmar.png'), // Imagem 1
 

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