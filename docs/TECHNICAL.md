# Technischer Entwurf

Stand der Quellenprüfung: 6. Oktober 2026. App-Einstieg, Menüs, Trainingsansicht, TrainingController und RecordingService sind als Grundgerüst implementiert. MetricsProvider, GaitTracker und SensorCapture folgen später. SDK 9.2.0 und die Venu-3S-Gerätedateien sind eingerichtet. Build und erster Simulatorlauf für `venu3s` sind erfolgreich. Die Ergebnisse stehen in [SIMULATOR_TEST.md](SIMULATOR_TEST.md). Gerätevalidierung steht noch aus.

## Plattform und Quellen

Das Grundgerüst ist eine eigenständige Connect-IQ-Watch-App in Monkey C für das Produktziel `venu3s`. Garmin führt die Venu 3S als Connect-IQ-Gerät mit rundem AMOLED-Display und 390 × 390 Pixeln. Das Manifest setzt vorläufig API 3.2.0 als Minimum und die Berechtigungen `Fit`, `FitContributor`, `Sensor` und `Positioning`. Als SDK ist Version 9.2.0, Build `2026-06-09-92a1605b2`, eingerichtet. Quelle: [Garmin-Gerätereferenz](https://developer.garmin.com/connect-iq/articles/device-reference/venu3s.html).

Für FIT-Aufzeichnungen nutzt RecordingService `ActivityRecording.createSession()` und `Activity.SPORT_HORSEBACK_RIDING`. Die Sportkonstanten im ActivityRecording-Modul sind inzwischen veraltet; das Grundgerüst verwendet die Konstanten aus Activity. Quelle: [ActivityRecording](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityRecording.html).

Eine Session bietet `start()`, `stop()`, `save()`, `discard()` und `addLap()`. Pausieren wird im App-Modell über Stoppen und erneutes Starten derselben Session abgebildet; dieses Verhalten wird im Prototyp validiert. Rückgabewerte müssen geprüft werden. Quelle: [ActivityRecording.Session](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityRecording/Session.html).

Für spätere Sensorfenster ist `Sensor.registerSensorDataListener()` vorgesehen. Gerätesupport, zulässige Abtastraten und Auswirkungen auf Akku und Speicher werden vor der Datensammlung im installierten SDK und auf der Uhr geprüft. Quelle: [Sensor](https://developer.garmin.com/connect-iq/api-docs/Toybox/Sensor.html).

## Komponenten

| Komponente | Verantwortung |
| --- | --- |
| App und Eingabedelegaten | Lebenszyklus, Navigation, Tasten und Touch |
| TrainingController | Zustandswechsel, Modus und erlaubte Aktionen |
| RecordingService | Garmin-Session, FIT, Runden und Speicherfehler |
| MetricsProvider | Puls, GPS-Status, Distanz und Geschwindigkeit mit Verfügbarkeitsstatus |
| GaitTracker | Manuelle Gangart, Übergangszeiten und aufsummierte aktive Zeiten |
| Views | Vorbereitung, Livewerte, Gangarten und Zusammenfassung |
| SensorCapture, später | Begrenzte Sensorfenster, Zeitbezug und Export für Analyse |

Die Oberfläche greift über die Komponenten auf Garmin-Funktionen zu. Zeitrechnung und Gangartenlogik sollen möglichst unabhängig von der Anzeige bleiben.

## Zustandsmodell

`Bereit → Aufzeichnung ↔ Pause → Abschluss → Gespeichert / Verworfen`

Aus Abschluss kann das Training fortgesetzt werden. Speichern oder Verwerfen beendet die Session erst nach bestätigtem Erfolg. Bei einem Fehler bleibt die Abschlussansicht mit einer verständlichen Meldung und erneuter Speichermöglichkeit erhalten.

* Gangartenwechsel und Abschnittsmarker sind nur während aktiver Aufzeichnung wirksam.
* Beim Pausieren wird das laufende Gangartenintervall abgeschlossen.
* Beim Fortsetzen beginnt ein neues Intervall mit der zuletzt gewählten Gangart.
* Trainingszeiten stammen aus dem Aufzeichnungszeitbezug, nicht aus der Anzahl der Bildschirmaktualisierungen.
* Ein fehlender Messwert ist kein Nullwert. GPS-Ausfälle dürfen keine künstlichen Geschwindigkeitsspitzen erzeugen.
* Der Modus bleibt für die laufende Session fest. GPS ist im Hallenmodus aus.

## FIT und Datensammlung

Basiswerte werden über die Garmin-Aufzeichnung gespeichert. Trainingsabschnitte sollen zunächst FIT-Runden nutzen. Für Gangarten und Zusammenfassungen werden FIT-Developer-Felder geprüft. Welche Daten Garmin Connect tatsächlich anzeigt, wird mit einer synchronisierten Testaktivität überprüft.

Hochfrequente Rohbeschleunigung wird nicht pauschal als gewöhnliches FIT-Developer-Feld eingeplant. Vor Phase 3 wird ein begrenzter Aufzeichnungs- und Exportweg prototypisiert und hinsichtlich Datenmenge, Zeitstempeln und Gerätegrenzen bewertet. Das Design soll keinen ganzen Ritt im Arbeitsspeicher puffern.

Ein geeignetes Analyseformat muss Sensorzeitstempel, X/Y/Z-Werte, manuelle Gangartenlabels und Pausen eindeutig auf dieselbe Zeitachse beziehen. Merkmalsextraktion und Klassifikator folgen erst nach nachgewiesenem Datenexport.

## Erster technischer Meilenstein

1. Connect IQ SDK, Venu-3S-Gerätedateien und Monkey-C-Werkzeuge einrichten; verwendete Version dokumentieren.
2. Manifest, Jungle-Konfiguration, Ressourcen und minimale Watch App anlegen.
3. Lokalen Entwicklerschlüssel außerhalb der Versionsverwaltung konfigurieren.
4. App für `venu3s` kompilieren und im Simulator starten.
5. Moduswahl, Start/Pause/Fortsetzen und Speichern/Verwerfen implementieren.
6. GPS und Herzfrequenz integrieren; fehlende Messwerte prüfen.
7. Auf der echten Venu 3S testen und eine gespeicherte Reitaktivität in Garmin Connect kontrollieren.

## Noch zu validieren

* Konkrete SDK-Version, Manifest-Berechtigungen und minimale API-Version.
* Tatsächliche Tastenereignisse und Bedienbarkeit während des Reitens.
* Pause/Fortsetzen sowie Distanz- und Geschwindigkeitsverhalten im FIT-Ergebnis.
* Darstellung eigener FIT-Felder und Runden in Garmin Connect.
* Sensorfrequenz, Exportweg, Akkuverbrauch und Speicherbedarf für Phase 3.
* Verhalten bei App-Abbruch oder Neustart; Wiederherstellung ist vor einem stabilen Release zu untersuchen.

## Messwerte im aktuellen Prototyp

Puls stammt aus `Sensor.enableSensorEvents`, GPS aus `Position.enableLocationEvents`. Pulswerte bis einschlie?lich null/0 sowie Messwerte ?lter als f?nf Sekunden sind nicht verf?gbar. GPS-Geschwindigkeit wird nur mit frischem QUALITY_USABLE oder QUALITY_GOOD angezeigt; die Einheit wird von m/s nach km/h umgerechnet. Distanz stammt aus der Garmin-Aktivit?t. In Bereitschaft wird keine Distanz einer fr?heren Session angezeigt. GPS und Puls werden beim Verlassen, Speichern, Verwerfen und App-Ende abgeschaltet. App-Abbruch speichert nicht automatisch und stellt keine Session wieder her. Quellen: [Sensor](https://developer.garmin.com/connect-iq/api-docs/Toybox/Sensor.html), [Position](https://developer.garmin.com/connect-iq/api-docs/Toybox/Position.html), [Activity.Info](https://developer.garmin.com/connect-iq/api-docs/Toybox/Activity/Info.html), [FitContributor](https://developer.garmin.com/connect-iq/api-docs/Toybox/FitContributor.html).
