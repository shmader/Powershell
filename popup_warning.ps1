$a = new-object -comobject wscript.shell

$b = $a.popup(“User session will end automatically after 15 minutes of inactivity and all browser history and saved files will be deleted! 

Please finish all of your work before leaving your PC. “,0,“WARNING! ”,1)