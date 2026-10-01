import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lopputyo/data/database.dart';
import 'package:lopputyo/komponentit/dialog_box.dart';
import 'package:lopputyo/komponentit/packing_tile.dart';
import 'package:lopputyo/komponentit/custom_app_bar.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Hive-laatikko, johon tehtävät tallennetaan
  final _mybox = Hive.box('mybox');
  PackingDataBase db = PackingDataBase();

  @override
  void initState() {
    super.initState();
    
    // Jos sovellus avataan ensimmäistä kertaa, avataan oletusdata
    if (_mybox.get("PAKKAUSLISTA") == null) {
      db.createInitialData();
    } else {
      // Ladataan olemassa oleva data mikäli ei eka kerta
      db.loadData();
    }
  }

  // Tekstikontrolleri käyttäjän syötettä varten
  final _controller = TextEditingController();

  // Funktio, joka kutsutaan, kun checkboxia napautetaan
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.PackingList[index][1] = !db.PackingList[index][1];
    });
    db.updateDataBase(); // Päivitetään tietokanta muutosten jälkeen
  }

  // Tallenna uusi pakkauskohde
  void saveNewItem() {
    setState(() {
      db.PackingList.add([_controller.text, false]);
      _controller.clear(); // Tyhjennetään tekstikenttä
    });
    Navigator.of(context).pop(); // Suljetaan dialogi
    db.updateDataBase(); // Päivitetään tietokanta
  }

  // Luo uusi pakkauskohde
  void addNewItem() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewItem,
          onCancel: () => Navigator.of(context).pop(), // Suljetaan dialogi, jos käyttäjä peruu
        );
      },
    );
  }

  // Poista tehtävä
  void deleteItem(int index) {
    setState(() {
      db.PackingList.removeAt(index);
    });
    db.updateDataBase(); // Päivitetään tietokanta muutosten jälkeen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Pakkauslista'), // Käytetään mukautettua AppBaria
      floatingActionButton: FloatingActionButton(
        onPressed: addNewItem, // Avataan dialogi uuden pakkauskohteen lisäämistä varten
        backgroundColor: Colors.teal[100],
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.PackingList.length, // Pakkauskohteiden määrä
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PackingTile(
              itemName: db.PackingList[index][0], // Pakattavan kohteen nimi
              itemPacked: db.PackingList[index][1], // Pakkauksen tila tila (suoritettu/suorittamatta)
              onChanged: (value) => checkBoxChanged(value, index), // Checkboxin tilan muutos
              deleteFunction: (context) => deleteItem(index), // Pakkauskohteen poisto
            ),
          );
        },
      ),
    );
  }
}
