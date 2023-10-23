import 'package:chamada_inteligente/view/home_aluno.dart';
import 'package:chamada_inteligente/view/home_page.dart';
import 'package:chamada_inteligente/view/home_professor.dart';
import 'package:chamada_inteligente/form/form_input.dart';
import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/login_controller.dart';
import '../helper/database_helper.dart';
import '../model/user.dart';
import 'cadastro.dart';

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
        backgroundColor: ThemeColors.appBar,
        title: Text(
          "Agendar Chamada",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
            Switch(
              value: isCallActive,
              onChanged: (value) {
                setState(() {
                  isCallActive = value; // Atualiza o estado do switch
                });
              },
            ),
        ],
      ),
      backgroundColor: ThemeColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                color: ThemeColors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "DIA:",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.text,
              ),
            ),
            Text(
              "TER QUI",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "HORÁRIO:",
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.text,
              ),
            ),
            Row(
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
                      color: ThemeColors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 10),
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
                      color: ThemeColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ThemeColors.purple,
                  onPrimary: ThemeColors.background,
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
      ),
    );
  }
}
