import 'package:hive/hive.dart';

// Luokka, joka hallinnoi tietokantaa
class PackingDataBase {

  List PackingList = []; // Lista, johon pakattavat tallennetaan

  // Hive-laatikko johon pakkauslista tallennetaan
  final _myBox = Hive.box('mybox');

  // Metodi, joka suoritetaan, jos sovellus avataan ensimmäistä kertaa
  void createInitialData() {
    PackingList = [
      ["Tee pakkauslista", false], // Näytetään oletustehtävä ja määritellään checkboxin tila falseksi
    ];
  }

  // Metodi, joka lataa tiedot tietokannasta
  void loadData() {
    PackingList = _myBox.get("PAKKAUSLISTA"); // Haetaan pakkauslista tietokannasta
  }

  // Metodi, joka päivittää tietokannan tiedot
  void updateDataBase() {
    _myBox.put("PAKKAUSLISTA", PackingList); // Tallennetaan pakkauslista tietokantaan
  }
}
