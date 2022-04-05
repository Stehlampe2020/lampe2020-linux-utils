#!/bin/bash
datei1="$(zenity --file-selection --title="Wählen Sie ein PNG-Bild aus:" --file-filter="PNG-Bild | *.png")"
while [[ ! -f "$datei1" ]] && [[ ! -z "$datei1" ]]
do
datei1="$(zenity --file-selection --title="Wählen Sie ein PNG-Bild aus:" --file-filter="PNG-Bild | *.png")"
done
# [[ ! -z "$datei1" ]] && exit || echo "Ausgewählte PNG-Datei: $datei1"
datei2="$(zenity --file-selection --title="Wählen Sie ein .7z-Archiv oder .zip-Archiv aus:" --file-filter="Archiv | *.7z *.zip")"
while [[ ! -f "$datei2" ]] && [[ ! -z "$datei2" ]]
do
datei2="$(zenity --file-selection --title="Wählen Sie ein .7z-Archiv oder .zip-Archiv aus:" --file-filter="Archiv | *.7z *.zip")"
done
# [[ ! -z "$datei2" ]] && exit || echo "Ausgewählte Archivdatei: $datei1"
cat "$datei1" "$datei2" > "$(zenity --file-selection --title="Wählen Sie einen Speicherort für das neue PNG-Bild aus:" --save --confirm-overwrite --filename="*.png" --file-filter="PNG-Bild | *.png")"
