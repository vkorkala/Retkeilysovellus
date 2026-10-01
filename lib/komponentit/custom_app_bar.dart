import 'package:flutter/material.dart';

// Luokka, joka näyttää mukautetun appBarin
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Sivun otsikko

  const CustomAppBar({
    super.key,
    required this.title, 
  })  : preferredSize = const Size.fromHeight(90.0); //AppBarille varattava tila

  @override
  final Size preferredSize; 

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.teal[800], // Asetetaan sovelluspalkin taustaväri
      centerTitle: true, // Keskitetään otsikko
      leadingWidth: double.infinity, // Asetetaan leveys koko käytettävissä olevaan tilaan
      title: Text(
        title.toUpperCase(), // Muutetaan otsikko isoiksi kirjaimiksi
        style: TextStyle(
          fontWeight: FontWeight.w300, 
          letterSpacing: 10,
          color: Colors.teal[50], 
        ),
      ),
      toolbarHeight: 90.0, // Määritellään sovelluspalkin korkeus
    );
  }
}
