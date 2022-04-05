# lampe2020-linux-utils
This is a collection of self-made (but not all self-invented) linux programs, most of them are shell scripts.   
Some of them may (at first) only be available in German.   
   
# List of all the programs with their own description
## createarchvepng
This little tool takes a PNG image and a ZIP or 7z archive, adds the archive's contents to the PNG image and stores the results in a specified PNG file.   
This PNG file still functions as a PNG image which shows the original image but can also be opened with e.g. 7zip to reveal the files inside.   

## edit-commandlist
[quickedit](#quickedit), but modified to only open `$HOME/.bash_history`   

## quickedit
This little program copies the opened file to a variable to be able to restore it and then puts the file's content into an editable `zenity` text window. When the user clicks OK or presses <kbd>Ctrl</kbd>+<kbd>Enter</kbd>, the content of the `zenity` text window is saved to the original file. If something fails an error message will be displayed and the original file content will be tried to restore, this may fail with the current version.   
I will soon add a functionality to copy the opened file to another file instead of a variable, to fully avoid the interpretation of the file's content when restoring it.   
