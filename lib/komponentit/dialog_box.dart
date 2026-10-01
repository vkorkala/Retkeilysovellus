import 'package:flutter/material.dart';

// DialogBox-luokka, joka näyttää ponnahdus(?)ikkunan jossa voi lisätä pakattavan kohteen
class DialogBox extends StatelessWidget {
  final TextEditingController controller; // Tekstikontrolleri kirjoitettavaa tekstiä varten
  final VoidCallback onSave; // Funktio, joka suoritetaan tallennettaessa
  final VoidCallback onCancel; // Funktio, joka suoritetaan peruutettaessa

  //Konstruktori, joka ottaa vastaan vaaditut parametrit ja välittää ne edelleen
  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.teal[100],
      content: SizedBox(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            // Tekstikenttä kirjoittamista varten
            TextField(
              controller: controller, // Yhdistetään kontrolleriin
              decoration: const InputDecoration(
                border: OutlineInputBorder(), 
                hintText: "Lisää pakattavaa",
              ),
            ),

            // Painikkeet Hylkää ja Tallenna
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Hylkää-painike
                MyButton(text: "Hylkää", onPressed: onCancel), 

                const SizedBox(width: 20), // Lisätään tila painikkeiden väliin

                // Tallenna-painike
                MyButton(text: "Tallenna", onPressed: onSave), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Luokka painikkeille
class MyButton extends StatelessWidget {
  final String text; // Painikkeen teksti
  final VoidCallback onPressed; // Funktio, joka suoritetaan painettaessa

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed, // Suoritetaan annettu funktio painettaessa
      color: Colors.teal[700],
      child: Text(
        text, // Asetetaan painikkeen teksti
        style: const TextStyle(color: Colors.white, letterSpacing: 3), // Asetetaan tekstin tyyli
      ),
    );
  }
}
