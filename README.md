# Western Ride

Garmin-App fÃ¼r Westernreiten in der Halle, auf dem AuÃŸenplatz und beim Ausritt. Das verbindliche erste ZielgerÃ¤t ist die **Garmin Venu 3S**.

Dieses Repository enthÃ¤lt die Projektgrundlage fÃ¼r die Entwicklung mit Garmin Connect IQ und Monkey C.

## Projektstatus

Das erste Monkey-C-GrundgerÃ¼st ist angelegt: Moduswahl, Trainingsansicht, aktive Dauer und eine FIT-Aufzeichnungssteuerung mit Start, Pause, Fortsetzen, Speichern und bestÃ¤tigtem Verwerfen. Manifest und Build-Konfiguration zielen auf die Venu 3S. Die Bezeichnung â€žWestern Rideâ€œ ist ein Arbeitsname.

Connect IQ SDK 9.2.0, die Monkey-C-Erweiterung und die Venu-3S-GerÃ¤tedateien sind auf dem Entwicklungsrechner eingerichtet. Der Build fÃ¼r `venu3s` ist erfolgreich und erzeugt `bin/WesternRide.prg`. Im Simulator wurden Moduswahl, Start, Pause, Fortsetzen und Speichern geprÃ¼ft. Die gespeicherten FIT-Dateien sind gÃ¼ltige ReitaktivitÃ¤ten. GerÃ¤tevalidierung steht aus. GPS, Puls, Gangarten und Trainingsabschnitte sind noch nicht implementiert. Alle drei Modi zeichnen in diesem Stand dieselben Basisdaten mit unterschiedlichem AktivitÃ¤tsnamen auf.

## Geplanter Umfang

* Drei Trainingsmodi: Halle, Platz und Ausritt.
* AktivitÃ¤t als Reiten aufzeichnen, pausieren, fortsetzen, beenden und speichern.
* Trainingsdauer und Herzfrequenz des Reiters anzeigen.
* GPS, Distanz und Geschwindigkeit passend zum Trainingsmodus verwenden.
* Schritt, Jog und Lope zunÃ¤chst manuell markieren und Zeiten je Gangart erfassen.
* Trainingsabschnitte markieren und nach dem Ritt eine Zusammenfassung anzeigen.
* SpÃ¤ter Sensordaten sammeln und automatische Gangarterkennung anhand echter Trainings prÃ¼fen.

## Dokumentation

* [Produktdefinition und Entwicklungsplan](docs/PROJECT.md)
* [Technischer Entwurf und Validierung](docs/TECHNICAL.md)
* [Einrichtung, Build und erster Funktionstest](docs/DEVELOPMENT.md)
* [Ergebnisse des ersten Simulatorlaufs](docs/SIMULATOR_TEST.md)

## NÃ¤chster Meilenstein

Auf der echten Venu 3S Moduswahl, Aufzeichnungssteuerung und das Speichern einer ReitaktivitÃ¤t testen. AnschlieÃŸend die synchronisierte AktivitÃ¤t in Garmin Connect prÃ¼fen.

Build- und Simulator-Skripte liegen unter `scripts/`. Private SignierschlÃ¼ssel und persÃ¶nliche Trainingsdaten gehÃ¶ren nicht ins Repository.
