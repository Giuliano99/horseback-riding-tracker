# Western Ride

Garmin-App für Westernreiten in der Halle, auf dem Außenplatz und beim Ausritt. Das verbindliche erste Zielgerät ist die **Garmin Venu 3S**.

Dieses Repository enthält die Projektgrundlage für die Entwicklung mit Garmin Connect IQ und Monkey C.

## Projektstatus

Das erste Monkey-C-Grundgerüst ist angelegt: Moduswahl, Trainingsansicht, aktive Dauer und eine FIT-Aufzeichnungssteuerung mit Start, Pause, Fortsetzen, Speichern und bestätigtem Verwerfen. Manifest und Build-Konfiguration zielen auf die Venu 3S. Die Bezeichnung „Western Ride“ ist ein Arbeitsname.

Connect IQ SDK 9.2.0, die Monkey-C-Erweiterung und die Venu-3S-Gerätedateien sind auf dem Entwicklungsrechner eingerichtet. Der Build für `venu3s` ist erfolgreich und erzeugt `bin/WesternRide.prg`. Im Simulator wurden Moduswahl, Start, Pause, Fortsetzen und Speichern geprüft. Die gespeicherten FIT-Dateien sind gültige Reitaktivitäten. Gerätevalidierung steht aus. GPS, Puls, Gangarten und Trainingsabschnitte sind noch nicht implementiert. Alle drei Modi zeichnen in diesem Stand dieselben Basisdaten mit unterschiedlichem Aktivitätsnamen auf.

## Geplanter Umfang

* Drei Trainingsmodi: Halle, Platz und Ausritt.
* Aktivität als Reiten aufzeichnen, pausieren, fortsetzen, beenden und speichern.
* Trainingsdauer und Herzfrequenz des Reiters anzeigen.
* GPS, Distanz und Geschwindigkeit passend zum Trainingsmodus verwenden.
* Schritt, Jog und Lope zunächst manuell markieren und Zeiten je Gangart erfassen.
* Trainingsabschnitte markieren und nach dem Ritt eine Zusammenfassung anzeigen.
* Später Sensordaten sammeln und automatische Gangarterkennung anhand echter Trainings prüfen.

## Dokumentation

* [Produktdefinition und Entwicklungsplan](docs/PROJECT.md)
* [Technischer Entwurf und Validierung](docs/TECHNICAL.md)
* [Einrichtung, Build und erster Funktionstest](docs/DEVELOPMENT.md)
* [Ergebnisse des ersten Simulatorlaufs](docs/SIMULATOR_TEST.md)

## Nächster Meilenstein

Auf der echten Venu 3S Moduswahl, Aufzeichnungssteuerung und das Speichern einer Reitaktivität testen. Anschließend die synchronisierte Aktivität in Garmin Connect prüfen.

Build- und Simulator-Skripte liegen unter `scripts/`. Private Signierschlüssel und persönliche Trainingsdaten gehören nicht ins Repository.
