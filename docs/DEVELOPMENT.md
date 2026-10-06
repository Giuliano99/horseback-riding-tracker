# Entwicklung auf Windows

## Vorhandener Stand

* `manifest.xml`: Watch App mit festem Ziel `venu3s`, API-Minimum 3.2.0 und Berechtigungen Fit, FitContributor, Sensor und Positioning.
* `monkey.jungle`: Quellcode- und Ressourcenpfade.
* `source/`: App-Einstieg, Modusmenü, Trainingsansicht, Zustandssteuerung und Garmin-Aufzeichnung.
* `resources/`: App-Name und eigenes einfaches Hufeisen-Icon in 70 × 70 Pixeln.
* `scripts/`: Build und Übergabe an den laufenden Simulator.

GPS, Pulsanzeige, Gangarten, Abschnittsmarker und Wiederherstellung nach App-Abbruch sind noch offen. Die Moduswahl setzt aktuell den Aktivitätsnamen, aktiviert aber keine GPS-Funktionen. Die dargestellte Dauer wird anhand von `System.getTimer()` berechnet; eine Übereinstimmung mit der FIT-Timerzeit ist im Test zu prüfen.

## Voraussetzungen

1. [Garmin Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/) installieren und darin ein SDK sowie die Gerätedateien für Venu 3S herunterladen.
2. In VS Code die Erweiterung `garmin.monkey-c` installieren. Das Repo enthält eine Erweiterungsempfehlung.
3. Einen lokalen Garmin-Entwicklerschlüssel im DER-Format bereitstellen. Private Schlüssel bleiben außerhalb des Repos.
4. SDK-Pfad auf den entpackten SDK-Ordner setzen, der `bin/monkeyc.bat` enthält. Er zeigt nicht auf den SDK Manager.

## Build

Auf dem eingerichteten Entwicklungsrechner sind die Benutzerpfade bereits hinterlegt. Daher genügt:

```powershell
./scripts/build.ps1
```

Die Venu-3S-Gerätedateien sind auf dem Entwicklungsrechner installiert; der erste Build ist erfolgreich. Bei Einrichtung auf einem anderen Rechner müssen diese Dateien über den SDK Manager heruntergeladen werden. Ohne sie meldet der Compiler `Invalid device id specified: 'venu3s'`.

Im Repository-Ordner aus PowerShell aufrufen. Beispielpfade an die lokale Installation anpassen:

```powershell
./scripts/build.ps1 -SdkPath 'C:\Tools\ConnectIQ\sdk' -DeveloperKey 'C:\Keys\developer_key.der'
```

Alternativ lesen beide Skripte `CONNECT_IQ_SDK`; das Build-Skript liest zusätzlich `CONNECT_IQ_DEVELOPER_KEY`. Falls diese Variablen in einer bereits geöffneten Shell fehlen, lesen die Skripte die dauerhaft gespeicherten Benutzerwerte. Das Ergebnis liegt in `bin/WesternRide.prg`. Das Skript meldet fehlende Voraussetzungen und Compilerfehler als Fehler, statt Erfolg vorzutäuschen.

## Lokale SDK-Installation

Am 6. Oktober 2026 wurden direkt aus offiziellen Garmin-Downloads eingerichtet:

* SDK Manager 1.0.16 unter `%LOCALAPPDATA%\Garmin\ConnectIQ\SDKManager`.
* Connect IQ SDK 9.2.0 unter `%APPDATA%\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-9.2.0-2026-06-09-92a1605b2`.
* Die VS-Code-Erweiterung `garmin.monkey-c` in Version 1.1.3.
* Ein lokaler RSA-Entwicklerschlüssel im PKCS8-DER-Format unter `%APPDATA%\Garmin\ConnectIQ\Keys\western-ride.der`.

`CONNECT_IQ_SDK` und `CONNECT_IQ_DEVELOPER_KEY` sind als Benutzervariablen gespeichert. Das SDK wurde bei zuvor fehlender Konfiguration in `current-sdk.cfg` als aktives SDK hinterlegt. Die Installationsdateien und der Schlüssel sind nicht Teil des Repos.

SDK Manager öffnen:

```powershell
& "$env:LOCALAPPDATA\Garmin\ConnectIQ\SDKManager\sdkmanager.exe"
```

Bei einer neuen Einrichtung dort die Ersteinrichtung und Garmin-Anmeldung abschließen, dann im Gerätebereich die Venu 3S samt benötigten Ressourcen herunterladen. SDK 9.2.0 als aktives SDK wählen, falls der Manager danach fragt. Auf dem aktuellen Entwicklungsrechner ist dieser Schritt abgeschlossen.

## Simulator

Den Connect-IQ-Simulator über die Monkey-C-Erweiterung starten, dann:

```powershell
./scripts/simulate.ps1 -SdkPath 'C:\Tools\ConnectIQ\sdk'
```

Das Skript übergibt die zuvor gebaute App mit `monkeydo` an das Ziel `venu3s`. Vor einem erneuten Simulatorlauf nach Codeänderungen erneut bauen.

Der Aufruf kann aktiv bleiben, solange die App im Simulator läuft. Eine noch offene PowerShell ohne Ausgabe bedeutet deshalb allein keinen Fehler. Zum Beenden der App von der Moduswahl aus die simulierte Zurück-Taste drücken. Der Simulator kann für einen weiteren Lauf geöffnet bleiben.

## Bedienung des Grundgerüsts

1. Halle, Platz oder Ausritt im Startmenü auswählen.
2. In der Trainingsansicht startet die Auswahlaktion die Aufzeichnung.
3. Erneute Auswahl pausiert; noch eine Auswahl setzt fort.
4. Zurück oder Menü pausiert eine laufende Aufzeichnung und öffnet Weiter, Speichern und Verwerfen.
5. Verwerfen öffnet eine separate Bestätigung. Abbrechen ist der erste Eintrag.
6. Speichern oder bestätigtes Verwerfen führt bei Erfolg zur Moduswahl zurück.

Bei einem Speicherfehler bleibt die Session erhalten. Die Trainingsansicht zeigt eine kurze Fehlermeldung; Zurück öffnet erneut die Optionen. Zurück aus dem Optionsmenü lässt das Training pausiert. Ein erneuter Start ist ausdrücklich nötig.

Die konkrete physische Tastenbelegung und Bildschirmdarstellung sind noch auf Simulator und Uhr zu prüfen.

## Funktionstest nach dem ersten Build

| Prüfung | Erwartung |
| --- | --- |
| Jeden der drei Modi öffnen | Passender Modusname; Dauer beginnt bei 00:00:00 |
| Start, einige Sekunden warten | Dauer steigt; Garmin-Session zeichnet auf |
| Pause, einige Sekunden warten | Dauer bleibt stehen |
| Fortsetzen | Dauer steigt weiter, dieselbe Session bleibt erhalten |
| Zurück während der Aufzeichnung | Training pausiert vor dem Öffnen der Optionen |
| Optionen mit Zurück verlassen | Training bleibt pausiert |
| Verwerfen öffnen und abbrechen | Session bleibt erhalten |
| Verwerfen bestätigen | Rückkehr zur Moduswahl; keine gespeicherte Aktivität |
| Speichern | Rückkehr zur Moduswahl; genau eine FIT-Aktivität vorhanden |
| Speichern schlägt fehl | Kein Erfolgszustand; erneutes Speichern möglich |
| Neue Aktivität nach Speichern | Dauer und Session beginnen neu |

Auf der echten Uhr anschließend eine gespeicherte Aktivität synchronisieren und Sporttyp Reiten, Dauer und Pausen in Garmin Connect prüfen. SDK-Version, Firmware und Ergebnis der Tests dokumentieren.

## Bisherige Validierung

Am 6. Oktober 2026 wurden XML-Wohlgeformtheit, Ressourcenverweise, Zielgerät und FIT-Berechtigung, Iconformat, VS-Code-Konfiguration sowie die PowerShell-Syntax geprüft. Der Build-Aufruf ohne SDK liefert die erwartete Einrichtungsfehlermeldung.

Der Compiler meldet erfolgreich `Connect IQ Compiler version: 9.2.0`. Nach Installation der Venu-3S-Gerätedateien wurde `scripts/build.ps1` erfolgreich ausgeführt: `BUILD SUCCESSFUL`, Ergebnis `bin/WesternRide.prg`. Beim ersten Build musste der Compiler eine `default.jungle`-Datei im SDK-Verzeichnis erzeugen; dafür benötigte der Aufruf Schreibzugriff außerhalb der Workspace-Sandbox.

Damit ist die App-Kompilierung für `venu3s` bestätigt. Am selben Tag wurden anschließend Bildschirmdarstellung, die Auswahl aller drei Modi, Start/Pause/Fortsetzen, Abschlussmenü, Abbrechen des Verwerfens und Speichern im Simulator geprüft. Die FIT-Dateien wurden mit Garmins offiziellem Python-FIT-SDK auf Integrität, Sporttyp, Sessionanzahl und Timerereignisse geprüft. Details und offene Tests stehen in [SIMULATOR_TEST.md](SIMULATOR_TEST.md).

## Automatische Gangartentests

Bei laufendem Simulator `./scripts/test.ps1` ausf?hren. Das Skript baut eine separate Test-App. Gepr?ft werden Gangartenwechsel, nicht zugeordnete Zeit, unver?nderte Zeit bei Pause und die Summe aller Zeitkonten. Danach `./scripts/build.ps1` und `./scripts/simulate.ps1` f?r die normale App nutzen.

FIT-Feld 0 enth?lt den Gangartencode: 0 unbekannt, 1 Stillstand, 2 Schritt, 3 Jog, 4 Lope. Felder 1 bis 5 enthalten die jeweilige aktive Zeit in Sekunden als Session-Zusammenfassung. Die tats?chliche Darstellung in Garmin Connect muss nach dem ersten Uhrentest gepr?ft werden. Der Simulator ersetzt keine Pr?fung von GPS-Empfang, optischem Puls und Akkulaufzeit auf der Uhr.
