# Port Scanner Bash-Skript

Dieses Bash-Skript führt einen Port-Scan auf einer angegebenen IP-Adresse oder einem IP-Bereich durch und speichert die Ergebnisse in einer Datei. Es unterstützt verschiedene Listen von häufig verwendeten Ports und bietet grundlegende Funktionen zur Überprüfung von IP-Adressen.

## Funktionen

- Überprüft die Erreichbarkeit der angegebenen IP-Adresse(n).
- Führt einen Port-Scan auf den angegebenen Ports durch.
- Speichert die Ergebnisse in einer Datei, falls ein Dateiname angegeben wird.
- Unterstützt vorgegebene Portlisten: Top 10, Top 50 und Top 100 Ports.

## Nutzung

Das Skript verwendet `getopts` für die Verarbeitung von Befehlszeilenargumenten. Hier sind die verfügbaren Optionen:

Usage: ./port_scanner.sh -i IP -p PORTS -o OUTPUT_FILE -r RANGE

### Optionen
```perl
    - `-i IP`  
    Die IP-Adresse, die gescannt werden soll. (Erforderlich)

    - `-p PORTS`  
    Die Liste der Ports, die gescannt werden sollen:
    - `1` für die Top 10 Ports
    - `2` für die Top 50 Ports
    - `3` für die Top 100 Ports
    (Erforderlich)

    - `-o OUTPUT_FILE`  
    Der Name der Datei, in die die Ergebnisse geschrieben werden sollen. Der Dateiname wird im Verzeichnis `./Scanner_Results` gespeichert. (Optional)

    - `-r RANGE`  
    Der Bereich von IP-Adressen zum Scannen, z. B. `1-10`, wenn mehrere IP-Adressen gescannt werden sollen. (Optional)
```
## Beispiele

### Einzelne IP-Adresse scannen

Um die Top 10 Ports auf der IP-Adresse `192.168.1.1` zu scannen und die Ergebnisse in einer Datei namens `scan_results` zu speichern, führen Sie folgenden Befehl aus:

```bash
./port_scanner.sh -i 192.168.1.1 -p 1 -o scan_results
```

### IP-Bereich scannen

Um die Top 50 Ports auf einem Bereich von IP-Adressen 192.168.1.1 bis 192.168.1.10 zu scannen und die Ergebnisse in der Datei scan_results zu speichern, verwenden Sie:

```bash
./port_scanner.sh -i 192.168.1.1 -p 2 -o scan_results -r 1-10
```

### Nur scannen ohne Ausgabe in Datei

Um die Top 100 Ports auf der IP-Adresse 192.168.1.1 zu scannen, ohne die Ergebnisse in eine Datei zu schreiben, verwenden Sie:
```bash
./port_scanner.sh -i 192.168.1.1 -p 3
```
### Test

Um das Skript zu testen, können Sie die folgende Beispielkommandozeile verwenden. Diese scannen die IP-Adresse 127.0.0.1 auf die Top 10 Ports und speichern die Ergebnisse in test_results.txt:

```bash
./port_scanner.sh -i 127.0.0.1 -p 1 -o test_results
```
Überprüfen Sie die Datei ./Scanner_Results/test_results.txt, um die Ergebnisse des Scans zu sehen.

# Hinweis
Stellen Sie sicher, dass Sie die erforderlichen Berechtigungen haben, um auf die IP-Adressen zuzugreifen und Ports zu scannen. Das Skript verwendet nc (Netcat) für den Port-Scan, welches auf den meisten Unix-ähnlichen Systemen vorinstalliert ist.

# Lizenz
Dieses Skript ist Open Source und kann frei verwendet, verändert und verteilt werden. Es gibt keine Garantie für die Richtigkeit oder Vollständigkeit der Ergebnisse.

## Für Fragen oder Probleme können Sie das Skript gerne anpassen und einen PR stellen.
