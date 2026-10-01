import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PackingTile extends StatelessWidget {
  final String itemName; // Pakattavan kohteen nimi
  final bool itemPacked; // Onko kohde pakattu
  final Function(bool?)? onChanged; // Funktio, joka suoritetaan, kun checkboxin tila muuttuu
  final Function(BuildContext)? deleteFunction; // Funktio, joka suoritetaan, kun kohde poistetaan

  const PackingTile({
    super.key,
    required this.itemName,
    required this.itemPacked,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0), // Asetetaan tyhjää tilaa ympärille
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(), // Määritellään animaatio, kun tehtävää siirretään sivulle
          children: [
            SlidableAction(
              onPressed: deleteFunction, // Funktio, joka kutsutaan, kun pakattava kohde poistetaan
              icon: Icons.delete, // Roskakori-ikoni
              // Poistopainikkeen ulkoasu
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12), 
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16), // Asetetaan tyhjää tilaa containerin sisälle
          decoration: BoxDecoration(
            // Ulkoasua
            color: Colors.teal[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Checkbox joka kertoo onko kyseinen kohde pakattu vai ei
              Checkbox(
                value: itemPacked, // Checkboxin tila
                onChanged: onChanged, // Funktio, joka kutsutaan, kun tila muuttuu
                activeColor: Colors.black54, // Checkboxin väri, kun se on aktiivinen
              ),
              Flexible(
                child: Text(
                  itemName, // Pakattavan asian nimi
                  style: TextStyle(
                    //Tekstin ulkoasu
                    color: Colors.teal[50], 
                    letterSpacing: 3.0,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: itemPacked
                        ? TextDecoration.lineThrough // Yliviivaus, jos kohde on pakattu
                        : TextDecoration.none, // Ei yliviivausta, jos ei ole pakattu
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
