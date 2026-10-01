import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lopputyo/komponentit/navigation.dart';

void main() async {
  // Alustetaan hive
  await Hive.initFlutter();

  // Avataan hive-laatikko johon on tallennettu pakkauslista
  var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Piilotetaan debug-banneri
        home: Navigation(), // Haetaan aloitussivu Navigationista
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ), // Asetetaan väriteema
      ),
    );
  }
}
