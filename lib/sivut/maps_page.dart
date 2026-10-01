import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:lopputyo/komponentit/custom_app_bar.dart'; 

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  final TextEditingController _controller = TextEditingController(); // Tekstikontrolleri kirjoitusta varten
  final MapController _mapController = MapController(); // Kontrolleri kartan hallintaan

  LatLng _center = LatLng(60.192059, 24.945831); // Oletussijainti Helsinki
  List<Marker> _markers = []; // Lista markkereista kartalla

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Haetaan käyttäjän sijainti sovelluksen käynnistyessä
  }

  /// Funktio käyttäjän sijainnin hakemiseen
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Tarkistetaan, ovatko paikannuspalvelut käytössä
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Paikannuspalvelut eivät ole käytössä
        print('Paikannuspalvelut eivät ole käytössä.');
        return;
      }

      // Tarkistetaan käyttöoikeudet
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Pyydetään käyttöoikeuksia
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Käyttöoikeudet estetty
          print('Sijaintikäyttöoikeudet estetty.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Käyttöoikeudet estetty pysyvästi
        print('Sijaintikäyttöoikeudet estetty pysyvästi.');
        return;
      }

      // Haetaan käyttäjän nykyinen sijainti
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _center = LatLng(position.latitude, position.longitude); // Päivitetään kartan keskikohta
        _mapController.move(_center, 15.0); // Siirretään kartta käyttäjän sijaintiin ja zoomataan

        // Lisätään markkeri käyttäjän sijaintiin
        _markers.add(
          Marker(
            point: _center,
            width: 40.0,
            height: 40.0,
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        );
      });
    } catch (e) {
      print('Virhe sijainnin haussa: $e'); // Tulostetaan mahdollinen virhe
    }
  }

  /// Funktio käyttäjän kirjoittaman sijainnin hakemiseen
  void _searchLocation() async {
    final query = _controller.text; // Haetaan käyttäjän kirjoittama paikka
    if (query.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'com.example.lopputyo',
      },
    );
    if (response.statusCode == 200) {
      final List data = json.decode(
        utf8.decode(response.bodyBytes), // Ääkkösten käsittely
      );
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        final LatLng newLocation = LatLng(lat, lon); // Uusi sijainti
        setState(() {
          _center = newLocation; // Päivitetään kartan keskikohta
          _mapController.move(newLocation, 15.0); // Siirretään kartta uuteen sijaintiin ja zoomataan
          _markers = [
            Marker(
              point: newLocation,
              width: 40.0,
              height: 40.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ];
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sijaintia ei löytynyt')),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Haku epäonnistui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: CustomAppBar(title: 'Kartta'), // Käytetään mukautettua AppBaria
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Syötä sijainti',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _searchLocation(), // Haetaan sijainti käyttäjän kirjoittaman tekstin perusteella
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.teal[100]!),
                ),
                  onPressed: _searchLocation, // Haetaan sijainti painikkeen avulla
                  child: Text('Hae',                   
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.teal[900],
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.w400,
                  ),),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center, // Asetetaan kartan keskikohta
                initialZoom: 10.0, // Asetetaan zoomaustaso
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.lopputyo',
                ),
                MarkerLayer(
                  markers: _markers, // Lisätään markkerit kartalle
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
