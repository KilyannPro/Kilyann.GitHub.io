@echo off
chcp 65001 >nul
setlocal EnableExtensions DisableDelayedExpansion
title Optimisation TV Stick Android
cd /d "%~dp0"

rem ============================================================
rem  Optimisation d'un TV Stick Android (Xiaomi Mi TV Stick...)
rem  Tout passe par ADB, l'outil officiel de Google.
rem  Aucun root, rien d'irréversible : l'option 4 du menu annule tout.
rem ============================================================

set "ICI=%~dp0"
set "LISTE=%ICI%applis.txt"
set "PATH=%ICI%platform-tools;%PATH%"

echo.
echo  ==========================================================
echo        Optimisation d'un TV Stick Android - Xiaomi
echo  ==========================================================

if exist "%LISTE%" goto :liste_ok
echo.
echo  [ERREUR] Le fichier applis.txt est introuvable.
echo  Extrais tout le dossier du ZIP avant de lancer ce script.
goto :fin
:liste_ok

call :verifier_adb
if errorlevel 1 goto :fin

rem ------------------------------------------------------------
rem  Connexion au stick
rem ------------------------------------------------------------
:demander_ip
set "DERNIERE="
if exist "%ICI%derniere-ip.txt" set /p DERNIERE=<"%ICI%derniere-ip.txt"
echo.
echo  Adresse IP du stick : sur la TV, va dans
echo  Paramètres ^> Réseau et Internet ^> clique sur ton Wi-Fi.
if defined DERNIERE echo  Appuie juste sur Entrée pour réutiliser : %DERNIERE%
set "SAISIE="
set /p "SAISIE= Adresse IP : "
set "IP=%DERNIERE%"
if not "%SAISIE%"=="" set "IP=%SAISIE%"
if "%IP%"=="" goto :demander_ip
set "IP=%IP: =%"
if "%IP%"=="" goto :demander_ip
set "CIBLE=%IP%:5555"
if not "%IP::=%"=="%IP%" set "CIBLE=%IP%"

:connecter
set "ANDROID_SERIAL=%CIBLE%"
echo.
echo  Connexion à %CIBLE% ...
adb connect %CIBLE%
ping -n 3 127.0.0.1 >nul 2>&1
call :etat_adb
if "%ETAT_ADB%"=="device" goto :connecte
if "%ETAT_ADB%"=="unauthorized" goto :non_autorise
echo.
echo  [!] Impossible de se connecter au stick. Vérifie que :
echo      - le stick et ce PC sont connectés à la même box ;
echo      - l'adresse IP est la bonne, elle peut changer après un redémarrage ;
echo      - « Débogage USB » est activé dans les Options pour les développeurs ;
echo      - si la TV affiche « Autoriser le débogage ? », accepte puis choisis R.
echo.
choice /c RIAQ /n /m " [R]éessayer, autre [I]P, [A]ssocier avec un code, ou [Q]uitter ? "
if errorlevel 4 goto :fin
if errorlevel 3 goto :associer
if errorlevel 2 goto :demander_ip
goto :connecter

:non_autorise
echo.
echo  [!] Regarde ta TV : une fenêtre « Autoriser le débogage USB ? » s'affiche.
echo      Coche « Toujours autoriser depuis cet ordinateur », puis choisis OK.
echo.
choice /c CQ /n /m " C'est fait ? [C]ontinuer ou [Q]uitter "
if errorlevel 2 goto :fin
adb disconnect %CIBLE% >nul 2>&1
goto :connecter

:associer
rem  Pour les modèles récents qui utilisent le « Débogage sans fil ».
echo.
echo  Sur la TV : Options pour les développeurs ^> Débogage sans fil
echo  ^> Associer l'appareil avec un code. Note l'adresse IP:port et le code.
set "ASSOC_ADR="
set "ASSOC_CODE="
set /p "ASSOC_ADR= Adresse IP:port d'association : "
set /p "ASSOC_CODE= Code à 6 chiffres : "
adb pair %ASSOC_ADR% %ASSOC_CODE%
echo.
echo  Saisis maintenant l'adresse IP:port affichée en haut de l'écran
echo  « Débogage sans fil » : le port est différent de celui de l'association.
goto :demander_ip

:connecte
>"%ICI%derniere-ip.txt" echo %IP%
call :infos

rem ------------------------------------------------------------
rem  Menu principal
rem ------------------------------------------------------------
:menu
echo.
echo  ----------------------------------------------------------
echo   1. Optimiser le stick, recommandé la première fois
echo   2. Nettoyage rapide : vider les caches et la mémoire
echo   3. Voir ce qui consomme le plus de mémoire
echo   4. Annuler : tout réactiver et remettre les animations
echo   5. Quitter
echo  ----------------------------------------------------------
choice /c 12345 /n /m " Ton choix [1-5] : "
if errorlevel 5 goto :fin
if errorlevel 4 goto :restaurer
if errorlevel 3 goto :memoire
if errorlevel 2 goto :nettoyage
goto :optimiser

rem ------------------------------------------------------------
rem  1. Optimisation complète
rem ------------------------------------------------------------
:optimiser
echo.
echo  [1/5] Animations accélérées
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
echo        [OK] Les menus s'ouvrent deux fois plus vite.

echo.
echo  [2/5] Applications qui tournent en arrière-plan
echo        Pour chacune : O pour la désactiver, N pour la garder.
echo        Rien n'est supprimé, l'option 4 du menu les réactive.
for /f "usebackq eol=# tokens=1,* delims=;" %%A in ("%LISTE%") do call :proposer "%%A" "%%B"

echo.
echo  [3/5] Nettoyage des caches et de la mémoire
call :nettoyer

echo.
echo  [4/5] Compilation des applications
echo        Les applis s'ouvriront plus vite. Durée : 5 à 20 minutes,
echo        ne débranche pas le stick pendant ce temps.
choice /c ON /n /m "        Lancer maintenant ? [O/N] "
if errorlevel 2 goto :optimiser_redemarrer
echo        Patiente...
adb shell cmd package bg-dexopt-job
echo        [OK] Compilation terminée.

:optimiser_redemarrer
echo.
echo  [5/5] Redémarrage
echo        Un redémarrage applique tous les changements proprement.
choice /c ON /n /m "        Redémarrer le stick maintenant ? [O/N] "
if errorlevel 2 goto :menu
adb reboot
echo.
echo  [OK] C'est fini, le stick redémarre.
goto :fin

rem ------------------------------------------------------------
rem  2. Nettoyage rapide
rem ------------------------------------------------------------
:nettoyage
echo.
call :nettoyer
goto :menu

rem ------------------------------------------------------------
rem  3. Mémoire utilisée par appli
rem ------------------------------------------------------------
:memoire
echo.
echo  Analyse en cours, quelques secondes...
echo.
adb shell "dumpsys meminfo | grep -A 12 'Total PSS by process'"
echo.
echo  Les applis en haut de la liste sont les plus gourmandes.
echo  Si tu ne t'en sers pas, désinstalle-les depuis les Paramètres de la TV.
goto :menu

rem ------------------------------------------------------------
rem  4. Restauration
rem ------------------------------------------------------------
:restaurer
echo.
choice /c ON /n /m " Réactiver toutes les applis de la liste et remettre les animations normales ? [O/N] "
if errorlevel 2 goto :menu
adb shell settings put global window_animation_scale 1
adb shell settings put global transition_animation_scale 1
adb shell settings put global animator_duration_scale 1
echo        [OK] Animations remises à la vitesse normale.
for /f "usebackq eol=# tokens=1,* delims=;" %%A in ("%LISTE%") do call :reactiver "%%A" "%%B"
echo.
echo  [OK] Annulation terminée.
goto :menu

rem ============================================================
rem  Sous-programmes
rem ============================================================

:verifier_adb
adb version >nul 2>&1
if not errorlevel 1 exit /b 0
echo.
echo  ADB, l'outil officiel de Google pour piloter Android, n'est pas installé.
echo  Téléchargement automatique depuis dl.google.com, environ 7 Mo...
set "DEST=%ICI%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $z=Join-Path $env:TEMP 'platform-tools.zip'; Invoke-WebRequest -UseBasicParsing 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile $z; Expand-Archive -Force $z $env:DEST; Remove-Item $z"
adb version >nul 2>&1
if not errorlevel 1 exit /b 0
echo.
echo  [ERREUR] Le téléchargement a échoué. Télécharge « SDK Platform-Tools pour Windows »
echo  sur developer.android.com/tools/releases/platform-tools, puis extrais le
echo  dossier platform-tools à côté de ce script.
exit /b 1

:etat_adb
set "ETAT_ADB=absent"
for /f "skip=1 tokens=1,2" %%a in ('adb devices') do if "%%a"=="%CIBLE%" set "ETAT_ADB=%%b"
exit /b 0

:infos
set "MODELE=inconnu"
set "VERSION=?"
set "RAM_TOTAL=?"
set "RAM_LIBRE=?"
for /f "delims=" %%M in ('adb shell getprop ro.product.model') do set "MODELE=%%M"
for /f "delims=" %%V in ('adb shell getprop ro.build.version.release') do set "VERSION=%%V"
for /f "tokens=1,2" %%a in ('adb shell cat /proc/meminfo') do (
  if "%%a"=="MemTotal:" set /a RAM_TOTAL=%%b/1024
  if "%%a"=="MemAvailable:" set /a RAM_LIBRE=%%b/1024
)
call :stockage
echo.
echo  [OK] Connecté à : %MODELE%, Android %VERSION%
echo       Mémoire  : %RAM_LIBRE% Mo libres sur %RAM_TOTAL% Mo
echo       Stockage : %STO_LIBRE% libres sur %STO_TOTAL%
exit /b 0

:stockage
set "STO_TOTAL=?"
set "STO_LIBRE=?"
for /f "skip=1 tokens=2,4" %%a in ('adb shell df -h /data') do (
  set "STO_TOTAL=%%a"
  set "STO_LIBRE=%%b"
)
exit /b 0

:nettoyer
call :stockage
echo        Stockage libre avant : %STO_LIBRE%
adb shell am kill-all
adb shell pm trim-caches 999G
call :stockage
echo        Stockage libre après : %STO_LIBRE%
echo        [OK] Caches vidés et applis en arrière-plan fermées.
exit /b 0

:etat
rem  Renvoie ETAT = actif, desactive ou absent pour le paquet %1
set "ETAT=absent"
for /f "delims=" %%R in ('adb shell "pm list packages -e | grep -qx package:%~1 && echo ETAT_ACTIF; pm list packages -d | grep -qx package:%~1 && echo ETAT_DESACTIVE" 2^>nul') do (
  if "%%R"=="ETAT_ACTIF" set "ETAT=actif"
  if "%%R"=="ETAT_DESACTIVE" set "ETAT=desactive"
)
exit /b 0

:proposer
if "%~1"=="" exit /b 0
call :etat "%~1"
if "%ETAT%"=="absent" exit /b 0
echo.
echo        - %~2
if "%ETAT%"=="desactive" goto :proposer_deja
choice /c ON /n /m "          Désactiver ? [O/N] "
if errorlevel 2 exit /b 0
set "REPONSE=rien"
for /f "delims=" %%R in ('adb shell pm disable-user --user 0 %~1 2^>nul') do set "REPONSE=%%R"
if "%REPONSE:disabled=%"=="%REPONSE%" goto :proposer_echec
echo          [OK] Désactivée.
exit /b 0
:proposer_echec
echo          [!] Ce modèle refuse de la désactiver, on passe à la suite.
exit /b 0
:proposer_deja
echo          Déjà désactivée.
exit /b 0

:reactiver
if "%~1"=="" exit /b 0
call :etat "%~1"
if not "%ETAT%"=="desactive" exit /b 0
adb shell pm enable %~1 >nul 2>&1
echo        [OK] Réactivée : %~2
exit /b 0

:fin
echo.
adb kill-server >nul 2>&1
pause
endlocal
exit /b 0
