# Erster Simulatorlauf

Datum: 6. Oktober 2026. Ziel: Venu 3S, im Simulator angezeigte API-Version 5.2.0. Build: Connect IQ SDK 9.2.0.

## Geprüfte Funktionen

| Funktion | Ergebnis |
| --- | --- |
| Moduswahl Halle, Platz, Ausritt | Alle drei Ansichten öffnen sich mit passendem Modusnamen |
| Trainingsansicht | Große Dauer und Status passen sichtbar in das runde Display |
| Start über obere simulierte Uhrentaste | Status wechselt von Bereit zu Training; Dauer steigt |
| Pause über obere Taste | Status Pausiert; Dauer bleibt bei 00:00:13 stehen |
| Fortsetzen über obere Taste | Status Training; Dauer läuft ab dem bisherigen Wert weiter |
| Zurück während Aufzeichnung | Aufzeichnung pausiert; Abschlussmenü erscheint |
| Verwerfen öffnen | Separate Bestätigung mit Abbrechen als erstem Eintrag |
| Verwerfen abbrechen | Rückkehr zum Abschlussmenü; Aktivität kann weiterhin gespeichert werden |
| Speichern | Rückkehr zur Moduswahl; abgeschlossene FIT-Datei vorhanden |
| Neue Moduswahl nach Speichern | Trainingsdauer beginnt wieder bei 00:00:00 |
| App beenden und erneut laden | App kann nach erneutem Build wieder gestartet werden |

## FIT-Prüfung

Die Simulator-Dateien liegen lokal unter `%TEMP%\com.garmin.connectiq\GARMIN\Activities`. Für die Prüfung wurde Garmins [offizielles FIT Python SDK](https://github.com/garmin/fit-python-sdk) in Version 21.217.0 unter dem ignorierten Ordner `bin/fit-validation-tools` installiert. Es wurden keine Testaktivitäten ins Repo aufgenommen oder zu Garmin Connect hochgeladen.

Erste Testaktivität, Halle:

* Dateiintegrität einschließlich CRC gültig; keine Decoderfehler.
* Genau eine Session mit Sporttyp `horseback_riding`.
* Aktive FIT-Dauer: 21,938 Sekunden. Die Abschlussansicht zeigt 00:00:21.
* FIT-Feld `total_elapsed_time`: 53,157 Sekunden. Die aktive Dauer schließt die Pause aus.
* Timerereignisse: Start, Stop all, Start, Stop all. Damit sind Pause und Fortsetzen in derselben Session gespeichert.

## Korrektur aus dem Test

Der ursprüngliche FIT-Profilname `Western Ride: Halle` erschien in der Datei nur als `Western Ride: H`. RecordingService verwendet deshalb jetzt die kürzeren Namen `Western Halle`, `Western Platz` und `Western Ausritt`.

Nach der Korrektur wurde die App erneut gebaut, geladen und eine kurze Ausritt-Testaktivität gespeichert. Die Datei ist gültig, enthält genau eine Reit-Session und speichert den Profilnamen `Western Ausritt` vollständig. Aktive Dauer: 14,843 Sekunden.

## Noch offen

* Bestätigtes Verwerfen und erzwungene Speicherfehler wurden in diesem Lauf nicht ausgeführt.
* GPS, Pulsanzeige, Gangarten und Trainingsabschnitte sind noch nicht implementiert.
* Verhalten bei App-Abbruch, längeren Trainings und Energiesparzuständen ist noch nicht systematisch geprüft.
* Bedienbarkeit auf dem Pferd, Akkuverbrauch und Synchronisation nach Garmin Connect benötigen eine echte Venu 3S.

Am Ende des Tests bleibt der Simulator mit der App in der Moduswahl geöffnet. Es läuft keine Trainingsaufzeichnung.
