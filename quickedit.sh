#!/bin/bash
printf "Überprüfen, ob alle Abhängigkeiten erfüllt sind..."
if [ -z $(command -v zenity) ]
then
    printf " FERTIG: \"zenity\" fehlt und wird jetzt versucht, nachzuinstallieren...\n"
    if [ $(command -v pkexec) ]
    then
        pkexec apt install zenity -y
    elif [[ ! -z $(command -v pkexec) ]]
    then
        printf "[FEHLER]: \"pkexec\" fehlt und wird jetzt versucht, nachzuinstallieren..."
        sudo apt install zenity -y
    fi
else
    printf " FERTIG: Nichts fehlt! \n"
fi
if [[ ! -z "$1" ]]
then
    filetoopen=$1
elif [ -z "$1" ]
then
    zenity --info --title="Hinweis - quickedit" --text="Sie haben keine Datei ausgewählt! \nim folgenden Dialog können Sie eine Datei zum Schnellbearbeiten auswählen.\nHinweis: Der \"Abbrechen\"-Knopf im Dateiauswahlfenster funktioniert (noch) nicht,\nzum Abbrechen drücken Sie bitte [Esc] oder schließen Sie das Dateiauswahlfenster." --ellipsize
    loop_already_tried_to_open_a_file=0
fi
while [[ ! -f "$filetoopen" ]]
do
    if [[ ! already_tried_to_open_a_file -eq 0 ]]
    then
        zenity --info --title="Hinweis - quickedit" --text="Die gewählte Datei existiert nicht! \nim folgenden Dialog können Sie eine Datei zum Schnellbearbeiten auswählen.\nDer \"Abbrechen\"-Knopf im Dateiauswahlfenster funktioniert (noch) nicht,\nzum Abbrechen drücken Sie bitte [Esc] oder schließen Sie das Dateiauswahlfenster." --ellipsize
    fi
    filetoopen=$(zenity --file-selection)
    if [ -z "$filetoopen" ]
    then
        zenity --info --title="quickedit" --text="Abgebrochen"
        exit
    fi
    loop_already_tried_to_open_a_file=1
done
zenity --info --title="Hinweis - quickedit" --text="Wenn Sie unter dem Textfeld im folgenden Fenster auf \"Abbrechen\" klicken oder das Textfeld leer ist wenn Sie\nunter dem Textfeld im folgenden Fenster auf \"OK\" klicken, wird die Datei nicht verändert.\nWenn Sie im Textfeld im folgenden Fenster [Esc] drücken, wird der Vorgang abgebrochen und\nwenn Sie im Textfeld im folgenden Fenster [Strg + Enter] drücken, wird der Inhalt des Textfeldes ausgewertet." --ellipsize
old_file_content="$(cat "$filetoopen")"
if [[ ! $status -eq 0 ]]
then
        # echo "Fehler $status!"
        zenity --info --title="quickedit - Fehler [$status]!" --text="Abbruch!\nBeim Sichern der Datei gab \"cat\" den Fehlercode $status zurück!"
	exit
fi

new_file_content="$(cat "$filetoopen" | zenity --text-info --title="\"$filetoopen\" - quickedit" --font="mono" --editable)"
if [ -z "$new_file_content" ]
then
	zenity --info --title="quickedit" --text="Abgebrochen"
elif [ "$new_file_content" == "$old_file_content" ]
then
	zenity --info --title="quickedit" --text="Abgebrochen! Keine Änderung erkannt!" --ellipsize
elif [[ ! -z "$new_file_content" ]] && [[ ! "$new_file_content" == "$old_file_content" ]]
	then
	printf "%s$new_file_content" "" > "$filetoopen"
	status=$?
	if [[ ! $status -eq 0 ]]
	then
		printf "%s$old_file_content\n" "" > $filetoopen
		zenity --info --title="quickedit - Fehler [$status]!" --text="Beim Speichern der Datei gab \"printf\" den Fehlercode $status zurück\nund die Datei wurde in den Originalzustand zurückgesetzt!" --ellipsize
	elif [ $status -eq 0 ]
	then
		zenity --info --title="quickedit" --text="Speichern erfolgreich!" --ellipsize
	fi
fi
