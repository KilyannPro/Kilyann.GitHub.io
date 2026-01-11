@echo off
echo Lancement du serveur local...
echo Le site va s'ouvrir dans votre navigateur par defaut.
echo Appuyez sur Ctrl+C pour arreter le serveur.
npx -y http-server . -o -c-1
pause
