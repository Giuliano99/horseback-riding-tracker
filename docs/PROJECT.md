# Produktdefinition und Entwicklungsplan

Stand: 6. Oktober 2026. Grundlage ist die bereitgestellte Projektbeschreibung. Die folgenden Details konkretisieren sie als ersten Arbeitsentwurf.

## Ziel

Eine auf der Garmin Venu 3S gut bedienbare Trainings-App für Westernreiten. Sie soll in der Halle ohne GPS sinnvoll funktionieren und beim Ausritt GPS für Strecke und Geschwindigkeit nutzen.

Die Herzfrequenz gehört zum Reiter. Pferdepuls und andere Pferdesensoren sind kein Bestandteil des ersten Umfangs.

## Trainingsmodi

| Modus | Basisdaten | GPS-Verhalten im ersten Entwurf |
| --- | --- | --- |
| Halle | Dauer, Reiterpuls, manuelle Gangarten, Abschnitte | Aus; keine GPS-Distanz oder Geschwindigkeit anzeigen |
| Platz | Wie Halle; ergänzend Distanz und Geschwindigkeit | Optional; auf kleinen Flächen als eingeschränkte Messung kennzeichnen |
| Ausritt | Wie Halle; zusätzlich Strecke und Geschwindigkeit | An; Empfangsstatus anzeigen und fehlende Werte kenntlich machen |

GPS-Messungen auf engen Linien und bei häufigen Wendungen müssen im Praxistest bewertet werden. Aus Gangarten wird im ersten Umfang keine Distanz geschätzt.

## Erste nutzbare Version

Die erste nutzbare Version umfasst Phase 1 und Phase 2. Phase 1 allein ist der technische Basisprototyp.

1. Vor dem Start Halle, Platz oder Ausritt auswählen.
2. Eine Aktivität als Reiten starten.
3. Aufzeichnung pausieren und fortsetzen.
4. Training beenden und zwischen Speichern, Verwerfen und Fortsetzen wählen. Verwerfen erfordert eine Bestätigung.
5. Aktive Trainingsdauer und Herzfrequenz anzeigen. Fehlende Werte als fehlend darstellen.
6. Bei aktivem GPS Distanz sowie aktuelle, durchschnittliche und maximale Geschwindigkeit anzeigen.
7. Schritt, Jog und Lope manuell auswählen. Stillstand und „unbekannt“ als getrennte Zustände berücksichtigen.
8. Zeit je Gangart erfassen. Pausenzeiten zählen weder zur aktiven Dauer noch zu den Gangartenzeiten.
9. Trainingsabschnitte manuell markieren.
10. Vor dem Speichern eine Zusammenfassung anzeigen und die Aktivität als FIT-Datei speichern.

Eine neu gestartete Aktivität beginnt mit Gangart „unbekannt“. Manuelle Angaben sind Trainingslabels und keine automatische Messung. Die Zeiten für Schritt, Jog, Lope, Stillstand und unbekannt sollen zusammen der aktiven Trainingsdauer entsprechen.

## Bedienung und Ansichten

* **Vorbereitung:** Moduswahl und GPS-Status, anschließend Start.
* **Live:** Große Trainingsdauer, aktuelle Gangart und Herzfrequenz. Im Freien zusätzlich Distanz und Geschwindigkeit.
* **Training:** Zeiten je Gangart und Anzahl der Abschnitte.
* **Pause/Ende:** Fortsetzen, Beenden und anschließend Speichern oder bestätigtes Verwerfen.
* **Zusammenfassung:** Aktive Dauer, Gangartenzeiten, Abschnitte und verfügbare GPS-Kennzahlen.

Kernaktionen sollen über Tasten erreichbar sein. Touch ergänzt die Bedienung. Die konkrete Tastenbelegung wird im Prototyp anhand der Venu 3S festgelegt und auf dem Pferd getestet. Start/Pause und Gangartwechsel benötigen klar unterscheidbare Aktionen.

Eine Trackansicht, Höhenmeter, Auto-Pause, Pferdeprofile, Links-/Rechtsarbeit und automatische Erkennung von Western-Manövern sind spätere Erweiterungen.

## Entwicklungsphasen

| Phase | Ergebnis | Abnahme |
| --- | --- | --- |
| 1: Basis-App | Venu-3S-Gerüst, Modi, Aufzeichnungssteuerung, Dauer, Puls, GPS, FIT | App läuft auf der Uhr; gespeicherte Aktivität erscheint nach Synchronisation in Garmin Connect als Reiten |
| 2: Western Training | Manuelle Gangarten, Gangartenzeiten, Abschnitte, Zusammenfassung | Wechsel und Pausen werden korrekt verrechnet; Bedienung bei einem echten Training erprobt |
| 3: Datensammlung | Zeitlich zugeordnete Sensorfenster und manuelle Labels | Export funktioniert; Zeitbezug, Speicherbedarf und Akkuverbrauch sind gemessen |
| 4: Smart Riding | Experimentelle automatische Gangarterkennung | Qualität an getrennten Trainingsdaten bewertet; unsichere Ergebnisse werden kenntlich gemacht |

Die Veröffentlichung im Connect IQ Store folgt erst nach stabiler Gerätevalidierung. Automatische Gangarterkennung ist ein Forschungsziel. Ihre Zuverlässigkeit muss anhand verschiedener Pferde, Reiter und Trainings geprüft werden. Spin, Sliding Stop, Rollback, Back-up und Sidepass werden erst danach untersucht.

## Praxistests

* Halle: Start ohne GPS, längere Aufzeichnung, fehlender Puls, Gangartwechsel und Pause.
* Platz: Enge Wendungen, unruhige Geschwindigkeit, optionale GPS-Nutzung.
* Ausritt: GPS-Fix, Empfangsverlust und Rückkehr des Empfangs, längere Strecke.
* In allen Modi: Tastenbedienung, Lesbarkeit, Speichern, bestätigtes Verwerfen und Akkuverbrauch.

Persönliche FIT-Dateien und Sensordaten werden lokal gesammelt. Für Datensammlung sind Tragehand, Pferd, Trainingsumgebung und ungefähre Labelverzögerung zu dokumentieren. Beispiele im Repository verwenden synthetische oder bewusst anonymisierte Daten.
