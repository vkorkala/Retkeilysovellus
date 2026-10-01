import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lopputyo/komponentit/custom_app_bar.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController(); // Tekstikontrolleri käyttäjän kirjoittamaa tekstiä varten
  String _city = ''; // Paikkakunta, jonka sää halutaan hakea
  List<dynamic> _forecast = []; // Sääennustelista
  bool _isLoading = false; // Onko tietojen lataus kesken

  /// Funktio sään hakemiseen OpenWeatherMap -API:sta
  void _fetchWeather() async {
    if (_city.isEmpty) return; // Palautetaan, jos paikkakuntaa ei ole syötetty

    setState(() {
      _isLoading = true; // Näytetään latausanimaatio
    });

    final apiKey = 'YOUR_API_KEY'; // API-avain
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=${Uri.encodeComponent(_city)}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url)); // Tehdään HTTP GET -pyyntö
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Puretaan JSON-vastaus
        setState(() {
          _forecast = data['list']; // Tallennetaan ennusteet
        });
      } else {
        setState(() {
          _forecast = []; // Tyhjennetään ennusteet, jos pyyntö epäonnistuu
        });
      }
    } catch (error) {
      setState(() {
        _forecast = []; // Tyhjennetään ennusteet virhetilanteessa
      });
    }

    setState(() {
      _isLoading = false; // Piilotetaan latausanimaatio
    });
  }

  /// Funktio tuulen suunnan määrittämiseen asteiden perusteella
  String _getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) {
      return 'Pohjoinen';
    } else if (degrees >= 22.5 && degrees < 67.5) {
      return 'Koillinen';
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return 'Itä';
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return 'Kaakko';
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return 'Etelä';
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return 'Lounas';
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return 'Länsi';
    } else if (degrees >= 292.5 && degrees < 337.5) {
      return 'Luode';
    }
    return 'Tuntematon';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: CustomAppBar(title: 'Sääennuste'), // Käytetään mukautettua AppBaria
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tekstikenttä paikkakunnan syöttämiseksi
            TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Syötä paikkakunta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _city = value; // Päivitetään paikkakunnan nimi
                });
              },
            ),
            const SizedBox(height: 15.0),
            // Hakupainike
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.teal[100]!),
                ),
                onPressed: _fetchWeather, // Painettaessa haetaan sää
                child: Text(
                  'Hae Sää',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.teal[900],
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Latausanimaatio, kun tietoja ladataan
            _isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
            // Sääennustelista
            Expanded(
              child: ListView.builder(
                itemCount: _forecast.length, // Ennustelistan pituus
                itemBuilder: (context, index) {
                  final forecast = _forecast[index];
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    forecast['dt'] * 1000, // Muutetaan aikaleima päivämääräksi
                  );
                  final iconCode = forecast['weather'][0]['icon'];
                  final temp = forecast['main']['temp'].round(); // Lämpötila
                  final windSpeed = forecast['wind']['speed'].toDouble(); // Tuulen nopeus
                  final windDirection = _getWindDirection(forecast['wind']['deg'].toDouble()); // Tuulen suunta

                  // Määritetään sademäärä ja sen tyyppi (vesi tai lumi)
                  double precipitation = 0.0;
                  if (forecast.containsKey('rain')) {
                    precipitation = (forecast['rain']['3h'] ?? 0.0).toDouble();
                  } else if (forecast.containsKey('snow')) {
                    precipitation = (forecast['snow']['3h'] ?? 0.0).toDouble();
                  }

                  // Palautetaan listan komponentti, jossa on ennusteen tiedot
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.teal[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        'https://openweathermap.org/img/wn/$iconCode@2x.png',
                        width: 50,
                        height: 80,
                      ),
                    ),
                    title: Text(
                      '${date.day}.${date.month}.${date.year} ${date.hour}:00', // Päivämäärä ja aika
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lämpötila: $temp°C', style: const TextStyle(fontSize: 16.0)),
                        Text('Tuuli: $windSpeed m/s $windDirection', style: const TextStyle(fontSize: 16.0)),
                        Text('Sademäärä: $precipitation mm', style: const TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
