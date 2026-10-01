import 'package:flutter/material.dart';
import 'package:lopputyo/sivut/packing_page.dart'; 
import 'package:lopputyo/sivut/weather_page.dart';
import 'package:lopputyo/sivut/maps_page.dart';

// Luokka joka hallitsee sovelluksen navigointia
class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0; // Valittu kohde

  // Lista widgeteistä, jotka näytetään bottomnavissa
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    WeatherPage(), 
    MapsPage(), 
  ];

  // Funktio, jota kutsutaan, kun käyttäjä napauttaa bottomnavin kohdetta
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Päivitetään valitun kohteen indeksi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // Näytetään valitun kohteen sisältö
      bottomNavigationBar: SizedBox(
        height: 90, // Asetetaan bottomnavin korkeus
        child: BottomNavigationBar(
          backgroundColor: Colors.teal[100], // Asetetaan bottomnavin taustaväri
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              // Lisätään ikonit ja selitetekstit
              icon: Icon(Icons.backpack), 
              label: 'Pakkaus', 
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sunny), 
              label: 'Sää', 
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map), 
              label: 'Kartta',
            ),
          ],
          currentIndex: _selectedIndex, // Tällä hetkellä valittuna olevan kohteen indeksi
          selectedItemColor: Colors.teal[900], // Valitun kohteen väri
          onTap: _onItemTapped, // Kutsutaan, kun käyttäjä napauttaa kohdetta
        ),
      ),
    );
  }
}
