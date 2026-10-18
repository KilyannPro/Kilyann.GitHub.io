@echo off
cd /d "%~dp0"
echo Lancement du serveur local sur http://localhost:5500
echo Appuyez sur Ctrl+C pour arreter le serveur.
start "" http://localhost:5500
where python >nul 2>nul
if %errorlevel%==0 (
    python -m http.server 5500
) else (
    npx -y http-server . -p 5500 -c-1
)
pause
