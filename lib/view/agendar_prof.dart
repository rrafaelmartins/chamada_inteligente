import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class AgendarProfScreen extends StatefulWidget {
  @override
  _AgendarProfScreenState createState() => _AgendarProfScreenState();
}

class _AgendarProfScreenState extends State<AgendarProfScreen> {
  bool isCallActive = false;
  TimeOfDay startTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 9, minute: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005AAA),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Agendar Chamada',
              style: TextStyle(color: Colors.white),
            ),
            Switch(
              value: isCallActive,
              onChanged: (value) {
                setState(() {
                  isCallActive = value; // Atualiza o estado do switch
                });
              },
              activeColor: Colors.white, // Cor do botão do switch quando ativo
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColors.background,
      body: Column(
          children: <Widget>[
            SizedBox(height: 100),
            Text(
              "Engenharia de Software II",
              style: TextStyle(
                fontSize: 18,
                color: ThemeColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Turma A1",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "DIA:",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "TER QUI",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "HORÁRIO:",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (selectedTime != null && selectedTime != startTime) {
                      setState(() {
                        startTime = selectedTime;
                      });
                    }
                  },
                  child: Text(
                    "INÍCIO: ${startTime.format(context)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 50),
                InkWell(
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (selectedTime != null && selectedTime != endTime) {
                      setState(() {
                        endTime = selectedTime;
                      });
                    }
                  },
                  child: Text(
                    "FIM: ${endTime.format(context)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF005AAA),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  // Implement action on button press
                },
                child: Text(
                  "Salvar Alterações",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
