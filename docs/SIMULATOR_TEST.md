# Erster Simulatorlauf

Datum: 6. Oktober 2026. Ziel: Venu 3S, im Simulator angezeigte API-Version 5.2.0. Build: Connect IQ SDK 9.2.0.

## GeprÃƒÆ’Ã‚Â¼fte Funktionen

| Funktion | Ergebnis |
| --- | --- |
| Moduswahl Halle, Platz, Ausritt | Alle drei Ansichten ÃƒÆ’Ã‚Â¶ffnen sich mit passendem Modusnamen |
| Trainingsansicht | GroÃƒÆ’Ã…Â¸e Dauer und Status passen sichtbar in das runde Display |
| Start ÃƒÆ’Ã‚Â¼ber obere simulierte Uhrentaste | Status wechselt von Bereit zu Training; Dauer steigt |
| Pause ÃƒÆ’Ã‚Â¼ber obere Taste | Status Pausiert; Dauer bleibt bei 00:00:13 stehen |
| Fortsetzen ÃƒÆ’Ã‚Â¼ber obere Taste | Status Training; Dauer lÃƒÆ’Ã‚Â¤uft ab dem bisherigen Wert weiter |
| ZurÃƒÆ’Ã‚Â¼ck wÃƒÆ’Ã‚Â¤hrend Aufzeichnung | Aufzeichnung pausiert; AbschlussmenÃƒÆ’Ã‚Â¼ erscheint |
| Verwerfen ÃƒÆ’Ã‚Â¶ffnen | Separate BestÃƒÆ’Ã‚Â¤tigung mit Abbrechen als erstem Eintrag |
| Verwerfen abbrechen | RÃƒÆ’Ã‚Â¼ckkehr zum AbschlussmenÃƒÆ’Ã‚Â¼; AktivitÃƒÆ’Ã‚Â¤t kann weiterhin gespeichert werden |
| Speichern | RÃƒÆ’Ã‚Â¼ckkehr zur Moduswahl; abgeschlossene FIT-Datei vorhanden |
| Neue Moduswahl nach Speichern | Trainingsdauer beginnt wieder bei 00:00:00 |
| App beenden und erneut laden | App kann nach erneutem Build wieder gestartet werden |

## FIT-PrÃƒÆ’Ã‚Â¼fung

Die Simulator-Dateien liegen lokal unter `%TEMP%\com.garmin.connectiq\GARMIN\Activities`. FÃƒÆ’Ã‚Â¼r die PrÃƒÆ’Ã‚Â¼fung wurde Garmins [offizielles FIT Python SDK](https://github.com/garmin/fit-python-sdk) in Version 21.217.0 unter dem ignorierten Ordner `bin/fit-validation-tools` installiert. Es wurden keine TestaktivitÃƒÆ’Ã‚Â¤ten ins Repo aufgenommen oder zu Garmin Connect hochgeladen.

Erste TestaktivitÃƒÆ’Ã‚Â¤t, Halle:

* DateiintegritÃƒÆ’Ã‚Â¤t einschlieÃƒÆ’Ã…Â¸lich CRC gÃƒÆ’Ã‚Â¼ltig; keine Decoderfehler.
* Genau eine Session mit Sporttyp `horseback_riding`.
* Aktive FIT-Dauer: 21,938 Sekunden. Die Abschlussansicht zeigt 00:00:21.
* FIT-Feld `total_elapsed_time`: 53,157 Sekunden. Die aktive Dauer schlieÃƒÆ’Ã…Â¸t die Pause aus.
* Timerereignisse: Start, Stop all, Start, Stop all. Damit sind Pause und Fortsetzen in derselben Session gespeichert.

## Korrektur aus dem Test

Der ursprÃƒÆ’Ã‚Â¼ngliche FIT-Profilname `Western Ride: Halle` erschien in der Datei nur als `Western Ride: H`. RecordingService verwendet deshalb jetzt die kÃƒÆ’Ã‚Â¼rzeren Namen `Western Halle`, `Western Platz` und `Western Ausritt`.

Nach der Korrektur wurde die App erneut gebaut, geladen und eine kurze Ausritt-TestaktivitÃƒÆ’Ã‚Â¤t gespeichert. Die Datei ist gÃƒÆ’Ã‚Â¼ltig, enthÃƒÆ’Ã‚Â¤lt genau eine Reit-Session und speichert den Profilnamen `Western Ausritt` vollstÃƒÆ’Ã‚Â¤ndig. Aktive Dauer: 14,843 Sekunden.

## Noch offen

* BestÃƒÆ’Ã‚Â¤tigtes Verwerfen und erzwungene Speicherfehler wurden in diesem Lauf nicht ausgefÃƒÆ’Ã‚Â¼hrt.
* Im ersten Lauf waren GPS, Pulsanzeige, Gangarten und Trainingsabschnitte noch nicht implementiert. GPS, Puls und manuelle Gangarten wurden anschlie?end erg?nzt; siehe Erweiterungstest unten.
* Verhalten bei App-Abbruch, lÃƒÆ’Ã‚Â¤ngeren Trainings und EnergiesparzustÃƒÆ’Ã‚Â¤nden ist noch nicht systematisch geprÃƒÆ’Ã‚Â¼ft.
* Bedienbarkeit auf dem Pferd, Akkuverbrauch und Synchronisation nach Garmin Connect benÃƒÆ’Ã‚Â¶tigen eine echte Venu 3S.

Am Ende des Tests bleibt der Simulator mit der App in der Moduswahl geÃƒÆ’Ã‚Â¶ffnet. Es lÃƒÆ’Ã‚Â¤uft keine Trainingsaufzeichnung.

## Erweiterungstest: GPS, Puls und Gangarten

Am selben Tag wurden GPS-Auswahl und neue Liveanzeige f?r Ausritt gepr?ft. Ohne Sensordaten zeigt die Anzeige Puls `--`, GPS-Suche und Geschwindigkeit `--`. Die Ansicht passt auf das runde Display. Zwei automatische Simulator-Tests f?r Gangartenwechsel, Pausenzeitbezug und Zeitkontensumme bestehen (2 bestanden, 0 Fehler).

Eine gespeicherte Ausritt-Testdatei ohne GPS-Fix hat g?ltige Integrit?t und keine Decoderfehler. Sie enth?lt genau eine Reit-Session, 55,813 Sekunden aktive Dauer und f?nf SESSION-Developer-Felder mit Zeiten. Nicht zugeordnete Zeit: 55,813 Sekunden; alle gew?hlten Gangarten: 0. Das RECORD-Feld Gangart ist mit 0 vorhanden. Die w?hrend der Bedienpr?fung entstandene Pause z?hlt nicht zur Gangartenzeit.

Die erste Touch-Pr?fung zeigte, dass BehaviorDelegate Tippen als Auswahlaktion verarbeitet. TrainingDelegate unterscheidet Start/Pause ?ber rohe Tastenereignisse von Tippen, das die Gangartenauswahl ?ffnet. Die Zur?ck- und Men?aktionen bleiben bei Garmins BehaviorDelegate.

Im GPS-Test wurden GPS bereit, Puls 162 bpm sowie steigende Distanz und Geschwindigkeit angezeigt. Zur?ck pausierte und ?ffnete das Abschlussmen?; Speichern f?hrte zur Moduswahl. Die gespeicherte Datei enth?lt genau eine Reit-Session und 63 GPS-Records. Aktive Dauer: 98,016 Sekunden, Distanz: 914,85 Meter. Gangartencodes 0 und 2 sowie Zeitkonten 84,407 Sekunden unbekannt und 13,609 Sekunden Schritt sind vorhanden; die Summe stimmt mit der FIT-Timerzeit ?berein. Die Datei hat g?ltige Integrit?t und keine Decoderfehler.

Der Simulator meldet mittleren/maximalen Puls in der Session, enth?lt in diesem GPS-Test aber keine nativen Herzfrequenz-RECORD-Felder. Deshalb muss auch die gespeicherte Pulskurve auf der echten Uhr gepr?ft werden. Alle Messwerte und Koordinaten dieses Tests stammen aus der Simulator-Datengenerierung.

Die endg?ltige Gangartenauswahl zeigt Unbekannt, Stillstand, Schritt, Jog und Lope gleichzeitig. Jog und Lope wurden per Touch gew?hlt und in der Trainingsansicht best?tigt. Die Auswahl schaltet keine Pause ein. Randbeschriftungen wurden f?r das runde Display gek?rzt.

Letzter Hallen-Test: FIT g?ltig, genau eine Reit-Session, Gangartencodes 0, 3 und 4 vorhanden. Aktive Dauer: 114,640 Sekunden; verstrichene Dauer: 147,047 Sekunden. Zeitkonten: Unbekannt 36,266 s, Jog 51,297 s und Lope 27,077 s. Summe entspricht der aktiven Dauer. Start, Stop, Start und Stop best?tigen Pause/Fortsetzen in derselben Session; Lope bleibt beim Fortsetzen gew?hlt. Die Pausenanzeige stand unver?ndert bei 00:01:44.

Die laufende Aktivit?tsdatensimulation schreibt auch im Hallen-Test synthetische GPS-Records, obwohl die App keine GPS-Ereignisse aktiviert und GPS aus anzeigt. F?r den Hallenmodus und Ohne GPS wird LOCATION_DISABLE inzwischen ausdr?cklich gesetzt. Das tats?chliche Fehlen einer Strecke im FIT muss auf der echten Uhr kontrolliert werden; aus diesem Simulatorlauf ist es nicht best?tigt.
