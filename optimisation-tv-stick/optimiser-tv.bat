@echo off
chcp 65001 >nul
setlocal EnableExtensions DisableDelayedExpansion
title Optimisation TV Stick Android
cd /d "%~dp0"

rem ============================================================
rem  Optimisation d'un TV Stick Android (Xiaomi Mi TV Stick...)
rem  Tout passe par ADB, l'outil officiel de Google.
rem  Aucun root, rien d'irréversible : l'option 6 du menu annule tout.
rem ============================================================

set "ICI=%~dp0"
set "LISTE=%ICI%applis.txt"
set "PATH=%ICI%platform-tools;%PATH%"
set "DNS_ANTIPUB=dns.adguard-dns.com"
set "DOSSIER_FONDS=/sdcard/Pictures/FondsEcran"
set "PROJECTIVY=com.spocky.projengmenu"
set "FLAUNCHER=me.efesser.flauncher"

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
echo   3. Wi-Fi : diagnostic, débit réel et DNS anti-pub
echo   4. Écran d'accueil moderne et fonds d'écran
echo   5. Voir ce qui consomme le plus de mémoire
echo   6. Annuler : tout remettre comme avant
echo   7. Quitter
echo  ----------------------------------------------------------
choice /c 1234567 /n /m " Ton choix [1-7] : "
if errorlevel 7 goto :fin
if errorlevel 6 goto :restaurer
if errorlevel 5 goto :memoire
if errorlevel 4 goto :accueil
if errorlevel 3 goto :wifi
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
echo        Rien n'est supprimé, l'option 6 du menu les réactive.
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
rem  3. Wi-Fi
rem ------------------------------------------------------------
:wifi
echo.
echo  [1/4] État de la connexion Wi-Fi
set "W_RSSI="
set "W_LIEN="
set "W_FREQ="
set "W_BANDE="
set "W_QUAL="
adb shell "dumpsys wifi | grep mWifiInfo | head -n 1 | grep -oE 'RSSI: -?[0-9]+|Link speed: [0-9]+|Frequency: [0-9]+'" >"%TEMP%\tvstick_wifi.txt" 2>nul
for /f "usebackq tokens=1,2 delims=:" %%a in ("%TEMP%\tvstick_wifi.txt") do (
  if "%%a"=="RSSI" set "W_RSSI=%%b"
  if "%%a"=="Link speed" set "W_LIEN=%%b"
  if "%%a"=="Frequency" set "W_FREQ=%%b"
)
del "%TEMP%\tvstick_wifi.txt" >nul 2>&1
if "%W_FREQ%"=="" goto :wifi_inconnu
set "W_FREQ=%W_FREQ: =%"
if "%W_RSSI%"=="" set "W_RSSI=-100"
set "W_RSSI=%W_RSSI: =%"
if "%W_LIEN%"=="" set "W_LIEN=?"
set "W_LIEN=%W_LIEN: =%"
set "W_BANDE=2,4 GHz"
if %W_FREQ% GEQ 4900 set "W_BANDE=5 GHz"
if %W_FREQ% GEQ 5925 set "W_BANDE=6 GHz"
set "W_QUAL=faible"
if %W_RSSI% GEQ -75 set "W_QUAL=moyen"
if %W_RSSI% GEQ -67 set "W_QUAL=bon"
if %W_RSSI% GEQ -55 set "W_QUAL=excellent"
echo        Bande        : %W_BANDE%
echo        Signal       : %W_QUAL%, %W_RSSI% dBm
echo        Vitesse lien : %W_LIEN% Mbit/s
goto :wifi_debit

:wifi_inconnu
echo        Le stick ne semble pas connecté en Wi-Fi : câble Ethernet,
echo        ou modèle qui ne donne pas cette information.

:wifi_debit
echo.
echo  [2/4] Mesure du débit réel entre ce PC et le stick, 30 secondes environ
choice /c ON /n /m "        Lancer la mesure ? [O/N] "
if errorlevel 2 goto :wifi_conseils
set "DEBIT="
adb shell "dd if=/dev/urandom of=/data/local/tmp/tvstick_test bs=1048576 count=8 2>/dev/null"
adb pull /data/local/tmp/tvstick_test tvstick_test >nul 2>&1
adb push tvstick_test /data/local/tmp/tvstick_test2 >"%TEMP%\tvstick_debit.txt" 2>&1
call :lire_debit "%TEMP%\tvstick_debit.txt"
adb shell rm -f /data/local/tmp/tvstick_test /data/local/tmp/tvstick_test2 >nul 2>&1
del tvstick_test >nul 2>&1
del "%TEMP%\tvstick_debit.txt" >nul 2>&1
if "%DEBIT%"=="" goto :wifi_debit_echec
set "W_AVIS=faible : risque de coupures, même en HD"
if %DEBIT% GEQ 10 set "W_AVIS=correct pour la HD, trop juste pour la 4K"
if %DEBIT% GEQ 25 set "W_AVIS=suffisant pour la 4K"
if %DEBIT% GEQ 50 set "W_AVIS=excellent, largement assez pour la 4K"
echo        Débit vers le stick : %DEBIT% Mbit/s, %W_AVIS%.
echo        Si ce PC est lui aussi en Wi-Fi, le vrai débit du stick est sans doute plus élevé.
goto :wifi_conseils
:wifi_debit_echec
echo        [!] Mesure impossible sur ce modèle, on passe à la suite.

:wifi_conseils
echo.
echo  [3/4] Conseils pour ton installation
if "%W_BANDE%"=="2,4 GHz" goto :wifi_conseil_bande
goto :wifi_conseil_signal
:wifi_conseil_bande
echo        - Ton stick est en 2,4 GHz : c'est le point le plus important.
echo          Connecte-le au réseau 5 GHz de ta box, plus rapide et sans
echo          interférences avec la télécommande Bluetooth. Si ta box n'affiche
echo          qu'un seul réseau, sépare les bandes 2,4 et 5 GHz dans ses réglages.
:wifi_conseil_signal
if "%W_QUAL%"=="faible" goto :wifi_conseil_faible
if "%W_QUAL%"=="moyen" goto :wifi_conseil_faible
goto :wifi_conseil_general
:wifi_conseil_faible
echo        - Signal trop faible : branche le stick avec une petite rallonge HDMI
echo          pour le sortir de derrière la TV, qui bloque les ondes. Rapproche
echo          la box ou ajoute un répéteur Wi-Fi.
:wifi_conseil_general
echo        - Laisse 1 m entre la box et les autres appareils sans fil, et évite
echo          de la poser dans un meuble fermé.
echo        - Si les coupures arrivent le soir, change le canal Wi-Fi dans
echo          l'interface de ta box : les voisins utilisent peut-être le même.

echo.
echo  [4/4] DNS anti-pub, optionnel
echo        Bloque une partie des pubs et des traqueurs dans les applis et
echo        sur l'écran d'accueil. Les pubs YouTube ne sont pas bloquées.
echo        Service gratuit utilisé : AdGuard DNS.
if "%VMAJ%"=="?" goto :wifi_dns_version_ok
if %VMAJ% LSS 9 goto :wifi_dns_non
:wifi_dns_version_ok
call :lire_dns
if "%DNS_MODE%"=="hostname" goto :wifi_dns_actif
choice /c ON /n /m "        Activer le DNS anti-pub ? [O/N] "
if errorlevel 2 goto :menu
adb shell settings put global private_dns_specifier %DNS_ANTIPUB%
adb shell settings put global private_dns_mode hostname
echo        Vérification de la connexion Internet...
call :tester_internet
if "%INTERNET%"=="ok" goto :wifi_dns_ok
call :dns_defaut
echo        [!] Ta box bloque ce type de DNS : réglage annulé, rien n'a changé.
goto :menu
:wifi_dns_ok
echo        [OK] DNS anti-pub activé, Internet fonctionne.
goto :menu
:wifi_dns_non
echo        [!] Il faut Android 9 ou plus récent pour ce réglage.
goto :menu
:wifi_dns_actif
echo        Un DNS privé est déjà actif : %DNS_HOTE%
choice /c ON /n /m "        Le désactiver ? [O/N] "
if errorlevel 2 goto :menu
call :dns_defaut
echo        [OK] DNS remis par défaut.
goto :menu

rem ------------------------------------------------------------
rem  4. Écran d'accueil et fonds d'écran
rem ------------------------------------------------------------
:accueil
echo.
echo  Écran d'accueil et fonds d'écran
echo        L'écran d'accueil d'origine n'accepte pas de fond d'écran. On le
echo        remplace par un écran plus propre, plus léger et sans publicités.
echo        Recherche des écrans d'accueil installés...
call :chercher_lanceur
if not "%LANCEUR%"=="" goto :accueil_installe
echo.
echo        Aucun n'est installé. Choisis-en un :
echo          P. Projectivy Launcher : le plus beau et le plus réglable. Il a ses
echo             propres fonds d'écran. Mettre ta propre image demande la version
echo             Premium, payante.
echo          F. FLauncher : simple, gratuit et open source. Ta propre image est
echo             gratuite, mais il faut aussi installer un gestionnaire de fichiers
echo             comme X-plore depuis le Play Store.
echo.
choice /c PFR /n /m "        Ouvrir sa page Play Store sur la TV : [P]rojectivy, [F]Launcher ou [R]etour ? "
if errorlevel 3 goto :menu
set "MAGASIN=%PROJECTIVY%"
if errorlevel 2 set "MAGASIN=%FLAUNCHER%"
adb shell "am start -a android.intent.action.VIEW -d 'market://details?id=%MAGASIN%'" >nul 2>&1
echo        La page s'ouvre sur la TV : clique sur Installer, puis reviens ici.
choice /c CR /n /m "        C'est installé ? [C]ontinuer ou [R]etour au menu "
if errorlevel 2 goto :menu
goto :accueil

:accueil_installe
for /f "tokens=1 delims=/" %%a in ("%LANCEUR%") do set "LANCEUR_PAQUET=%%a"
set "LANCEUR_NOM=%LANCEUR_PAQUET%"
if "%LANCEUR_PAQUET%"=="%PROJECTIVY%" set "LANCEUR_NOM=Projectivy Launcher"
if "%LANCEUR_PAQUET%"=="%FLAUNCHER%" set "LANCEUR_NOM=FLauncher"
echo        Trouvé : %LANCEUR_NOM%
echo.
echo  [1/3] %LANCEUR_NOM% devient l'écran d'accueil par défaut
set "REPONSE=rien"
for /f "delims=" %%R in ('adb shell cmd package set-home-activity %LANCEUR%') do set "REPONSE=%%R"
if "%REPONSE%"=="Success" goto :accueil_defaut_ok
echo        [!] Ce modèle refuse le changement automatique. Appuie sur le bouton
echo            Accueil de la télécommande : la TV te demandera peut-être lequel utiliser.
goto :accueil_origine
:accueil_defaut_ok
echo        [OK] Fait.

:accueil_origine
echo.
echo  [2/3] Écran d'accueil Google d'origine
set "STOCK=com.google.android.tvlauncher"
call :etat "%STOCK%"
if not "%ETAT%"=="absent" goto :accueil_origine_trouve
set "STOCK=com.google.android.leanbacklauncher"
call :etat "%STOCK%"
if not "%ETAT%"=="absent" goto :accueil_origine_trouve
echo        Sur ce modèle, il ne peut pas être désactivé. Si le bouton Accueil y
echo        ramène encore, active dans les réglages de %LANCEUR_NOM% l'option qui
echo        remplace le lanceur actuel.
goto :accueil_fonds
:accueil_origine_trouve
if "%ETAT%"=="desactive" goto :accueil_origine_deja
echo        Le désactiver est recommandé : sinon le bouton Accueil de la
echo        télécommande peut y ramener, et ça libère beaucoup de mémoire.
echo        L'option 6 du menu le remet si besoin.
choice /c ON /n /m "        Désactiver l'écran d'accueil Google ? [O/N] "
if errorlevel 2 goto :accueil_fonds
set "REPONSE=rien"
for /f "delims=" %%R in ('adb shell pm disable-user --user 0 %STOCK% 2^>nul') do set "REPONSE=%%R"
if "%REPONSE:disabled=%"=="%REPONSE%" goto :accueil_origine_echec
echo        [OK] Désactivé.
goto :accueil_fonds
:accueil_origine_echec
echo        [!] Ce modèle refuse de le désactiver. Si le bouton Accueil y ramène
echo            encore, active dans les réglages de %LANCEUR_NOM% l'option qui
echo            remplace le lanceur actuel.
goto :accueil_fonds
:accueil_origine_deja
echo        Déjà désactivé.

:accueil_fonds
echo.
echo  [3/3] Envoi des fonds d'écran sur la TV
set "NB_FONDS=0"
if not exist "fonds-ecran\*" goto :accueil_fonds_fin
adb shell mkdir -p %DOSSIER_FONDS% >nul 2>&1
if "%LANCEUR_PAQUET%"=="%PROJECTIVY%" adb shell mkdir -p /sdcard/Android/data/%PROJECTIVY%/files/wallpapers >nul 2>&1
rem  Chemins relatifs : le script s'est placé dans son propre dossier au démarrage.
for %%F in (fonds-ecran\*.jpg fonds-ecran\*.jpeg fonds-ecran\*.png) do call :envoyer_fond "%%~fF" "%%~nxF"
:accueil_fonds_fin
echo        [OK] %NB_FONDS% fonds d'écran envoyés dans le dossier Pictures ^> FondsEcran.
echo        Tu peux ajouter tes propres images dans le dossier fonds-ecran à côté
echo        de ce script, puis relancer cette option.
adb shell input keyevent KEYCODE_HOME >nul 2>&1
echo.
echo  Pour choisir ton fond d'écran sur la TV :
if "%LANCEUR_PAQUET%"=="%PROJECTIVY%" goto :accueil_aide_projectivy
echo    Ouvre les réglages de %LANCEUR_NOM%, partie fond d'écran, et choisis une
echo    image dans Pictures ^> FondsEcran. Si rien ne s'ouvre, installe le
echo    gestionnaire de fichiers X-plore depuis le Play Store et réessaie.
goto :menu
:accueil_aide_projectivy
echo    Dans les réglages de Projectivy : Apparence ^> Fond d'écran.
echo    Sans Premium, choisis un de ses fonds intégrés. Avec Premium, choisis
echo    « dossier défini par l'utilisateur » : les images y sont déjà copiées.
goto :menu

rem ------------------------------------------------------------
rem  5. Mémoire utilisée par appli
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
rem  6. Restauration
rem ------------------------------------------------------------
:restaurer
echo.
echo  Remet les animations, les applis de la liste, l'écran d'accueil Google
echo  et le DNS d'origine. Les fonds d'écran et les applis installées restent.
choice /c ON /n /m " Tout remettre comme avant ? [O/N] "
if errorlevel 2 goto :menu
adb shell settings put global window_animation_scale 1
adb shell settings put global transition_animation_scale 1
adb shell settings put global animator_duration_scale 1
echo        [OK] Animations remises à la vitesse normale.
for /f "usebackq eol=# tokens=1,* delims=;" %%A in ("%LISTE%") do call :reactiver "%%A" "%%B"
call :restaurer_accueil com.google.android.tvlauncher
call :restaurer_accueil com.google.android.leanbacklauncher
call :lire_dns
if not "%DNS_MODE%"=="hostname" goto :restaurer_fin
call :dns_defaut
echo        [OK] DNS remis par défaut.
:restaurer_fin
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
set "VMAJ=99"
for /f "tokens=1 delims=." %%v in ("%VERSION%") do set "VMAJ=%%v"
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

:lire_debit
rem  Lit la sortie d'« adb push » (%1) et renvoie DEBIT en Mbit/s
set "DEBIT="
set "LIGNE="
for /f "usebackq delims=" %%L in ("%~1") do set "LIGNE=%%L"
if "%LIGNE%"=="" exit /b 0
set "LIGNE=%LIGNE:(= %"
set "LIGNE=%LIGNE:)= %"
set "PREC="
for %%w in (%LIGNE%) do call :lire_debit_mot "%%w"
exit /b 0
:lire_debit_mot
if /i "%~1"=="MB/s" call :lire_debit_conv "%PREC%" mo
if /i "%~1"=="KB/s" call :lire_debit_conv "%PREC%" ko
set "PREC=%~1"
exit /b 0
:lire_debit_conv
set "ENT="
set "DEC=0"
for /f "tokens=1,2 delims=." %%a in ("%~1") do (
  set "ENT=%%a"
  if not "%%b"=="" set "DEC=%%b"
)
if "%ENT%"=="" exit /b 0
if "%~2"=="mo" set /a DEBIT=(ENT*10+DEC)*8/10
if "%~2"=="ko" set /a DEBIT=ENT*8/1000
exit /b 0

:lire_dns
set "DNS_MODE="
set "DNS_HOTE="
for /f "delims=" %%D in ('adb shell settings get global private_dns_mode') do set "DNS_MODE=%%D"
for /f "delims=" %%D in ('adb shell settings get global private_dns_specifier') do set "DNS_HOTE=%%D"
exit /b 0

:dns_defaut
adb shell settings put global private_dns_mode opportunistic >nul 2>&1
adb shell settings delete global private_dns_specifier >nul 2>&1
exit /b 0

:tester_internet
rem  Résout un nom de domaine depuis le stick, 3 essais : INTERNET = ok ou non
set "INTERNET=non"
for /f "delims=" %%R in ('adb shell "for i in 1 2 3; do sleep 3; ping -c 1 -W 3 www.example.com 2>&1 | grep -q ^PING && { echo INTERNET_OK; break; }; done"') do if "%%R"=="INTERNET_OK" set "INTERNET=ok"
exit /b 0

:chercher_lanceur
rem  Cherche une appli installée qui sait servir d'écran d'accueil : LANCEUR = paquet/activité
set "LANCEUR="
set "LANCEUR_PAQUET="
adb shell "for p in $(pm list packages -3 | cut -d: -f2); do c=$(cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME $p 2>/dev/null | tail -n 1 | tr -d ' '); case $c in */*) echo $c;; esac; done" >"%TEMP%\tvstick_lanceurs.txt" 2>nul
for /f "usebackq delims=" %%L in ("%TEMP%\tvstick_lanceurs.txt") do set "LANCEUR=%%L"
del "%TEMP%\tvstick_lanceurs.txt" >nul 2>&1
exit /b 0

:envoyer_fond
adb push "%~1" "%DOSSIER_FONDS%/%~2" >nul 2>&1
if errorlevel 1 exit /b 0
set /a NB_FONDS+=1
adb shell "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d 'file://%DOSSIER_FONDS%/%~2'" >nul 2>&1
if "%LANCEUR_PAQUET%"=="%PROJECTIVY%" adb push "%~1" "/sdcard/Android/data/%PROJECTIVY%/files/wallpapers/%~2" >nul 2>&1
exit /b 0

:restaurer_accueil
rem  Réactive l'écran d'accueil Google %1 s'il est présent et le remet par défaut
call :etat "%~1"
if "%ETAT%"=="absent" exit /b 0
if "%ETAT%"=="actif" goto :restaurer_accueil_defaut
adb shell pm enable %~1 >nul 2>&1
echo        [OK] Écran d'accueil Google réactivé.
:restaurer_accueil_defaut
adb shell "c=$(cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME %~1 | tail -n 1 | tr -d ' '); case $c in */*) cmd package set-home-activity $c;; esac" >nul 2>&1
exit /b 0

:fin
echo.
adb kill-server >nul 2>&1
pause
endlocal
exit /b 0
