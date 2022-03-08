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
zenity --info --title="Hinweis - edit-commandlist" --text="Wenn Sie unter dem Textfeld im folgenden Fenster auf \"Abbrechen\" klicken oder das Textfeld leer ist wenn Sie\nunter dem Textfeld im folgenden Fenster auf \"OK\" klicken, wird die Datei nicht verändert.\nWenn Sie im Textfeld im folgenden Fenster [Esc] drücken, wird der Vorgang abgebrochen und\nwenn Sie im Textfeld im folgenden Fenster [Strg + Enter] drücken, wird der Inhalt des Textfeldes ausgewertet." --ellipsize
old_file_content="$(cat $HOME/.bash_history)"
if [[ ! $status -eq 0 ]]
then
        # echo "Fehler $status!"
        zenity --info --title="edit-commandlist - Fehler \[$status\]!" --text="Abbruch!\nBeim Sichern der Datei gab \"cat\" den Fehlercode $status zurück!"
	exit
fi

new_file_content="$(cat $HOME/.bash_history | zenity --text-info --title="$HOME/.bash_history" --font="mono" --editable)"
if [ -z "$new_file_content" ]
then
	zenity --info --title="edit-commandlist" --text="Abgebrochen"
elif [ "$old_file_content" == "$new_file_content" ]
then
	zenity --info --title="edit-commandlist" --text="Abgebrochen! Keine Änderung erkannt!" --ellipsize
elif [[ ! -z "$new_file_content" ]] && [[ ! "$new_file_content" == "$old_file_content" ]]
	then
	printf "%s$new_file_content\n" "" > $HOME/.bash_history
	status=$?
	if [[ ! $status -eq 0 ]]
	then
		printf "%s$old_file_content\n" "" > $HOME/.bash_history
		zenity --info --title="edit-commandlist - Fehler \[$status\]!" --text="Beim Speichern der Datei gab \"printf\" den Fehlercode $status zurück\nund die Datei wurde in den Originalzustand zurückgesetzt!" --ellipsize
	elif [ $status -eq 0 ]
	then
		zenity --info --title="edit-commandlist" --text="Speichern erfolgreich!" --ellipsize
	fi
fi
