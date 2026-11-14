#!/usr/bin/env bash
# ============================================================
#  Optimisation d'un TV Stick Android (Xiaomi Mi TV Stick...)
#  Version macOS / Linux. Lancement : bash optimiser-tv.sh
#  Tout passe par ADB, l'outil officiel de Google.
#  Aucun root, rien d'irréversible : l'option 6 du menu annule tout.
# ============================================================
set -u

ICI="$(cd "$(dirname "$0")" && pwd)"
LISTE="$ICI/applis.txt"
export PATH="$ICI/platform-tools:$PATH"
DNS_ANTIPUB="dns.adguard-dns.com"
DOSSIER_FONDS="/sdcard/Pictures/FondsEcran"
PROJECTIVY="com.spocky.projengmenu"
FLAUNCHER="me.efesser.flauncher"
VMAJ=99

# --- Petits utilitaires ------------------------------------------------------

oui() { # oui "question" -> 0 si O, 1 si N
  local r
  while true; do
    read -r -p "$1 [O/N] " r
    case "$r" in [oO]*) return 0 ;; [nN]*) return 1 ;; esac
  done
}

tv() { adb shell "$@" </dev/null; } # commande sur le stick, sans lui passer le clavier

fin() {
  echo
  adb kill-server >/dev/null 2>&1
  exit "${1:-0}"
}

verifier_adb() {
  command -v adb >/dev/null 2>&1 && return 0
  local os tmp
  case "$(uname -s)" in
    Darwin) os=darwin ;;
    Linux) os=linux ;;
    *) echo " [ERREUR] Système non reconnu, installe ADB à la main."; return 1 ;;
  esac
  echo
  echo " ADB, l'outil officiel de Google pour piloter Android, n'est pas installé."
  echo " Téléchargement automatique depuis dl.google.com, environ 7 Mo..."
  tmp="$(mktemp -d)"
  if curl -fL --progress-bar -o "$tmp/platform-tools.zip" \
      "https://dl.google.com/android/repository/platform-tools-latest-$os.zip" \
    && unzip -q -o "$tmp/platform-tools.zip" -d "$ICI"; then
    rm -rf "$tmp"
    command -v adb >/dev/null 2>&1 && return 0
  fi
  rm -rf "$tmp"
  echo
  echo " [ERREUR] Le téléchargement a échoué. Installe ADB autrement :"
  echo "   macOS : brew install android-platform-tools"
  echo "   Linux : sudo apt install adb   (ou l'équivalent de ta distribution)"
  return 1
}

etat_adb() { # device, unauthorized, offline ou absent
  local e
  e="$(adb devices 2>/dev/null | tr -d '\r' | awk -v c="$CIBLE" '$1 == c { print $2 }')"
  echo "${e:-absent}"
}

etat() { # actif, desactive ou absent pour le paquet $1
  local r
  r="$(tv "pm list packages -e | grep -qx package:$1 && echo ETAT_ACTIF; pm list packages -d | grep -qx package:$1 && echo ETAT_DESACTIVE" 2>/dev/null)"
  case "$r" in
    *ETAT_DESACTIVE*) echo desactive ;;
    *ETAT_ACTIF*) echo actif ;;
    *) echo absent ;;
  esac
}

stockage() { # "libre|total" de la partition /data
  tv df -h /data 2>/dev/null | tr -d '\r' | awk 'NR == 2 { print $4 "|" $2 }'
}

pour_chaque_appli() { # pour_chaque_appli fonction -> appelle "fonction paquet description"
  local pkg desc
  while IFS=';' read -r pkg desc <&3; do
    pkg="${pkg%$'\r'}"
    desc="${desc%$'\r'}"
    case "$pkg" in '' | \#*) continue ;; esac
    "$1" "$pkg" "$desc"
  done 3<"$LISTE"
}

desactiver() { # 0 si le paquet $1 a bien été désactivé
  tv pm disable-user --user 0 "$1" 2>/dev/null | grep -q disabled
}

# --- Connexion ---------------------------------------------------------------

demander_ip() {
  local derniere=""
  [ -f "$ICI/derniere-ip.txt" ] && derniere="$(head -n 1 "$ICI/derniere-ip.txt" | tr -d '\r ')"
  IP=""
  while [ -z "$IP" ]; do
    echo
    echo " Adresse IP du stick : sur la TV, va dans"
    echo " Paramètres > Réseau et Internet > clique sur ton Wi-Fi."
    [ -n "$derniere" ] && echo " Appuie juste sur Entrée pour réutiliser : $derniere"
    read -r -p " Adresse IP : " IP
    IP="${IP// /}"
    [ -z "$IP" ] && IP="$derniere"
  done
  case "$IP" in *:*) CIBLE="$IP" ;; *) CIBLE="$IP:5555" ;; esac
  export ANDROID_SERIAL="$CIBLE"
}

associer() {
  local adr code
  echo
  echo " Sur la TV : Options pour les développeurs > Débogage sans fil"
  echo " > Associer l'appareil avec un code. Note l'adresse IP:port et le code."
  read -r -p " Adresse IP:port d'association : " adr
  read -r -p " Code à 6 chiffres : " code
  adb pair "$adr" "$code"
  echo
  echo " Saisis maintenant l'adresse IP:port affichée en haut de l'écran"
  echo " « Débogage sans fil » : le port est différent de celui de l'association."
}

connecter() {
  local r
  demander_ip
  while true; do
    echo
    echo " Connexion à $CIBLE ..."
    adb connect "$CIBLE"
    sleep 2
    case "$(etat_adb)" in
      device)
        echo "$IP" >"$ICI/derniere-ip.txt"
        return 0
        ;;
      unauthorized)
        echo
        echo " [!] Regarde ta TV : une fenêtre « Autoriser le débogage USB ? » s'affiche."
        echo "     Coche « Toujours autoriser depuis cet ordinateur », puis choisis OK."
        oui " C'est fait ? Continuer" || fin 0
        adb disconnect "$CIBLE" >/dev/null 2>&1
        ;;
      *)
        echo
        echo " [!] Impossible de se connecter au stick. Vérifie que :"
        echo "     - le stick et cet ordinateur sont connectés à la même box ;"
        echo "     - l'adresse IP est la bonne, elle peut changer après un redémarrage ;"
        echo "     - « Débogage USB » est activé dans les Options pour les développeurs ;"
        echo "     - si la TV affiche « Autoriser le débogage ? », accepte puis choisis R."
        echo
        read -r -p " [R]éessayer, autre [I]P, [A]ssocier avec un code, ou [Q]uitter ? " r
        case "$r" in
          [iI]*) demander_ip ;;
          [aA]*) associer; demander_ip ;;
          [qQ]*) fin 0 ;;
        esac
        ;;
    esac
  done
}

infos() {
  local modele version ram s
  modele="$(tv getprop ro.product.model | tr -d '\r')"
  version="$(tv getprop ro.build.version.release | tr -d '\r')"
  case "${version%%.*}" in '' | *[!0-9]*) VMAJ=99 ;; *) VMAJ="${version%%.*}" ;; esac
  ram="$(tv cat /proc/meminfo | tr -d '\r' | awk '
    /^MemTotal:/ { t = int($2 / 1024) }
    /^MemAvailable:/ { l = int($2 / 1024) }
    END { print l " Mo libres sur " t " Mo" }')"
  s="$(stockage)"
  echo
  echo " [OK] Connecté à : ${modele:-inconnu}, Android ${version:-?}"
  echo "      Mémoire  : $ram"
  echo "      Stockage : ${s%%|*} libres sur ${s##*|}"
}

# --- 1 et 2. Optimisation et nettoyage ---------------------------------------

nettoyer() {
  local avant apres
  avant="$(stockage)"
  echo "       Stockage libre avant : ${avant%%|*}"
  tv am kill-all
  tv pm trim-caches 999G
  apres="$(stockage)"
  echo "       Stockage libre après : ${apres%%|*}"
  echo "       [OK] Caches vidés et applis en arrière-plan fermées."
}

proposer() {
  local e
  e="$(etat "$1")"
  [ "$e" = absent ] && return 0
  echo
  echo "       - $2"
  if [ "$e" = desactive ]; then
    echo "         Déjà désactivée."
    return 0
  fi
  oui "         Désactiver ?" || return 0
  if desactiver "$1"; then
    echo "         [OK] Désactivée."
  else
    echo "         [!] Ce modèle refuse de la désactiver, on passe à la suite."
  fi
}

optimiser() {
  echo
  echo " [1/5] Animations accélérées"
  tv settings put global window_animation_scale 0.5
  tv settings put global transition_animation_scale 0.5
  tv settings put global animator_duration_scale 0.5
  echo "       [OK] Les menus s'ouvrent deux fois plus vite."

  echo
  echo " [2/5] Applications qui tournent en arrière-plan"
  echo "       Pour chacune : O pour la désactiver, N pour la garder."
  echo "       Rien n'est supprimé, l'option 6 du menu les réactive."
  pour_chaque_appli proposer

  echo
  echo " [3/5] Nettoyage des caches et de la mémoire"
  nettoyer

  echo
  echo " [4/5] Compilation des applications"
  echo "       Les applis s'ouvriront plus vite. Durée : 5 à 20 minutes,"
  echo "       ne débranche pas le stick pendant ce temps."
  if oui "       Lancer maintenant ?"; then
    echo "       Patiente..."
    tv cmd package bg-dexopt-job
    echo "       [OK] Compilation terminée."
  fi

  echo
  echo " [5/5] Redémarrage"
  echo "       Un redémarrage applique tous les changements proprement."
  if oui "       Redémarrer le stick maintenant ?"; then
    adb reboot
    echo
    echo " [OK] C'est fini, le stick redémarre."
    fin 0
  fi
}

# --- 3. Wi-Fi ----------------------------------------------------------------

lire_dns() {
  DNS_MODE="$(tv settings get global private_dns_mode | tr -d '\r')"
  DNS_HOTE="$(tv settings get global private_dns_specifier | tr -d '\r')"
}

dns_defaut() {
  tv settings put global private_dns_mode opportunistic >/dev/null 2>&1
  tv settings delete global private_dns_specifier >/dev/null 2>&1
}

tester_internet() { # 0 si le stick arrive à résoudre un nom de domaine (3 essais)
  tv "for i in 1 2 3; do sleep 3; ping -c 1 -W 3 www.example.com 2>&1 | grep -q ^PING && { echo INTERNET_OK; break; }; done" \
    2>/dev/null | grep -q INTERNET_OK
}

wifi() {
  local infos rssi lien freq bande="" qual="" debit avis sortie
  echo
  echo " [1/4] État de la connexion Wi-Fi"
  infos="$(tv "dumpsys wifi | grep mWifiInfo | head -n 1" 2>/dev/null | tr -d '\r')"
  rssi="$(printf '%s' "$infos" | grep -oE 'RSSI: -?[0-9]+' | grep -oE -- '-?[0-9]+')"
  lien="$(printf '%s' "$infos" | grep -oE 'Link speed: [0-9]+' | grep -oE '[0-9]+')"
  freq="$(printf '%s' "$infos" | grep -oE 'Frequency: [0-9]+' | grep -oE '[0-9]+')"
  if [ -n "$freq" ]; then
    rssi="${rssi:--100}"
    bande="2,4 GHz"
    [ "$freq" -ge 4900 ] && bande="5 GHz"
    [ "$freq" -ge 5925 ] && bande="6 GHz"
    qual="faible"
    [ "$rssi" -ge -75 ] && qual="moyen"
    [ "$rssi" -ge -67 ] && qual="bon"
    [ "$rssi" -ge -55 ] && qual="excellent"
    echo "       Bande        : $bande"
    echo "       Signal       : $qual, $rssi dBm"
    echo "       Vitesse lien : ${lien:-?} Mbit/s"
  else
    echo "       Le stick ne semble pas connecté en Wi-Fi : câble Ethernet,"
    echo "       ou modèle qui ne donne pas cette information."
  fi

  echo
  echo " [2/4] Mesure du débit réel entre cet ordinateur et le stick, 30 secondes environ"
  if oui "       Lancer la mesure ?"; then
    tv "dd if=/dev/urandom of=/data/local/tmp/tvstick_test bs=1048576 count=8 2>/dev/null"
    adb pull /data/local/tmp/tvstick_test "$ICI/tvstick_test" >/dev/null 2>&1
    sortie="$(cd "$ICI" && adb push tvstick_test /data/local/tmp/tvstick_test2 2>&1 </dev/null | tail -n 1)"
    tv rm -f /data/local/tmp/tvstick_test /data/local/tmp/tvstick_test2 >/dev/null 2>&1
    rm -f "$ICI/tvstick_test"
    debit="$(printf '%s' "$sortie" | awk '{ for (i = 2; i <= NF; i++) {
      if ($i == "MB/s") { printf "%d", $(i - 1) * 8; exit }
      if ($i == "KB/s") { printf "%d", $(i - 1) * 8 / 1000; exit } } }')"
    if [ -n "$debit" ]; then
      avis="faible : risque de coupures, même en HD"
      [ "$debit" -ge 10 ] && avis="correct pour la HD, trop juste pour la 4K"
      [ "$debit" -ge 25 ] && avis="suffisant pour la 4K"
      [ "$debit" -ge 50 ] && avis="excellent, largement assez pour la 4K"
      echo "       Débit vers le stick : $debit Mbit/s, $avis."
      echo "       Si cet ordinateur est lui aussi en Wi-Fi, le vrai débit du stick est sans doute plus élevé."
    else
      echo "       [!] Mesure impossible sur ce modèle, on passe à la suite."
    fi
  fi

  echo
  echo " [3/4] Conseils pour ton installation"
  if [ "$bande" = "2,4 GHz" ]; then
    echo "       - Ton stick est en 2,4 GHz : c'est le point le plus important."
    echo "         Connecte-le au réseau 5 GHz de ta box, plus rapide et sans"
    echo "         interférences avec la télécommande Bluetooth. Si ta box n'affiche"
    echo "         qu'un seul réseau, sépare les bandes 2,4 et 5 GHz dans ses réglages."
  fi
  if [ "$qual" = faible ] || [ "$qual" = moyen ]; then
    echo "       - Signal trop faible : branche le stick avec une petite rallonge HDMI"
    echo "         pour le sortir de derrière la TV, qui bloque les ondes. Rapproche"
    echo "         la box ou ajoute un répéteur Wi-Fi."
  fi
  echo "       - Laisse 1 m entre la box et les autres appareils sans fil, et évite"
  echo "         de la poser dans un meuble fermé."
  echo "       - Si les coupures arrivent le soir, change le canal Wi-Fi dans"
  echo "         l'interface de ta box : les voisins utilisent peut-être le même."

  echo
  echo " [4/4] DNS anti-pub, optionnel"
  echo "       Bloque une partie des pubs et des traqueurs dans les applis et"
  echo "       sur l'écran d'accueil. Les pubs YouTube ne sont pas bloquées."
  echo "       Service gratuit utilisé : AdGuard DNS."
  if [ "$VMAJ" -lt 9 ]; then
    echo "       [!] Il faut Android 9 ou plus récent pour ce réglage."
    return 0
  fi
  lire_dns
  if [ "$DNS_MODE" = hostname ]; then
    echo "       Un DNS privé est déjà actif : $DNS_HOTE"
    if oui "       Le désactiver ?"; then
      dns_defaut
      echo "       [OK] DNS remis par défaut."
    fi
    return 0
  fi
  oui "       Activer le DNS anti-pub ?" || return 0
  tv settings put global private_dns_specifier "$DNS_ANTIPUB"
  tv settings put global private_dns_mode hostname
  echo "       Vérification de la connexion Internet..."
  if tester_internet; then
    echo "       [OK] DNS anti-pub activé, Internet fonctionne."
  else
    dns_defaut
    echo "       [!] Ta box bloque ce type de DNS : réglage annulé, rien n'a changé."
  fi
}

# --- 4. Écran d'accueil et fonds d'écran -------------------------------------

chercher_lanceur() { # affiche paquet/activité d'une appli installée qui sait servir d'écran d'accueil
  tv "for p in \$(pm list packages -3 | cut -d: -f2); do c=\$(cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME \$p 2>/dev/null | tail -n 1 | tr -d ' '); case \$c in */*) echo \$c;; esac; done" \
    2>/dev/null | tr -d '\r' | tail -n 1
}

accueil() {
  local lanceur paquet nom stock e r n=0 f p
  echo
  echo " Écran d'accueil et fonds d'écran"
  echo "       L'écran d'accueil d'origine n'accepte pas de fond d'écran. On le"
  echo "       remplace par un écran plus propre, plus léger et sans publicités."
  while true; do
    echo "       Recherche des écrans d'accueil installés..."
    lanceur="$(chercher_lanceur)"
    [ -n "$lanceur" ] && break
    echo
    echo "       Aucun n'est installé. Choisis-en un :"
    echo "         P. Projectivy Launcher : le plus beau et le plus réglable. Il a ses"
    echo "            propres fonds d'écran. Mettre ta propre image demande la version"
    echo "            Premium, payante."
    echo "         F. FLauncher : simple, gratuit et open source. Ta propre image est"
    echo "            gratuite, mais il faut aussi installer un gestionnaire de fichiers"
    echo "            comme X-plore depuis le Play Store."
    echo
    read -r -p "       Ouvrir sa page Play Store sur la TV : [P]rojectivy, [F]Launcher ou [R]etour ? " r
    case "$r" in
      [pP]*) paquet="$PROJECTIVY" ;;
      [fF]*) paquet="$FLAUNCHER" ;;
      *) return 0 ;;
    esac
    tv "am start -a android.intent.action.VIEW -d 'market://details?id=$paquet'" >/dev/null 2>&1
    echo "       La page s'ouvre sur la TV : clique sur Installer, puis reviens ici."
    read -r -p "       C'est installé ? [C]ontinuer ou [R]etour au menu " r
    case "$r" in [cC]*) ;; *) return 0 ;; esac
  done

  paquet="${lanceur%%/*}"
  case "$paquet" in
    "$PROJECTIVY") nom="Projectivy Launcher" ;;
    "$FLAUNCHER") nom="FLauncher" ;;
    *) nom="$paquet" ;;
  esac
  echo "       Trouvé : $nom"

  echo
  echo " [1/4] $nom devient l'écran d'accueil par défaut"
  if tv cmd package set-home-activity "$lanceur" 2>/dev/null | grep -q Success; then
    echo "       [OK] Fait."
  else
    echo "       [!] Ce modèle refuse le changement automatique. Appuie sur le bouton"
    echo "           Accueil de la télécommande : la TV te demandera peut-être lequel utiliser."
  fi

  echo
  echo " [2/4] Écran d'accueil Google d'origine"
  stock=""
  for p in com.google.android.tvlauncher com.google.android.leanbacklauncher; do
    e="$(etat "$p")"
    if [ "$e" != absent ]; then stock="$p"; break; fi
  done
  if [ -z "$stock" ]; then
    echo "       Sur ce modèle, il ne peut pas être désactivé. Si le bouton Accueil y"
    echo "       ramène encore, active dans les réglages de $nom l'option qui"
    echo "       remplace le lanceur actuel."
  elif [ "$e" = desactive ]; then
    echo "       Déjà désactivé."
  else
    echo "       Le désactiver est recommandé : sinon le bouton Accueil de la"
    echo "       télécommande peut y ramener, et ça libère beaucoup de mémoire."
    echo "       L'option 6 du menu le remet si besoin."
    if oui "       Désactiver l'écran d'accueil Google ?"; then
      if desactiver "$stock"; then
        echo "       [OK] Désactivé."
      else
        echo "       [!] Ce modèle refuse de le désactiver. Si le bouton Accueil y ramène"
        echo "           encore, active dans les réglages de $nom l'option qui"
        echo "           remplace le lanceur actuel."
      fi
    fi
  fi

  echo
  echo " [3/4] Envoi des fonds d'écran sur la TV"
  if [ -d "$ICI/fonds-ecran" ]; then
    tv mkdir -p "$DOSSIER_FONDS" >/dev/null 2>&1
    [ "$paquet" = "$PROJECTIVY" ] && tv mkdir -p "/sdcard/Android/data/$PROJECTIVY/files/wallpapers" >/dev/null 2>&1
    for f in "$ICI"/fonds-ecran/*.jpg "$ICI"/fonds-ecran/*.jpeg "$ICI"/fonds-ecran/*.png; do
      [ -f "$f" ] || continue
      adb push "$f" "$DOSSIER_FONDS/$(basename "$f")" >/dev/null 2>&1 </dev/null || continue
      n=$((n + 1))
      tv "am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d 'file://$DOSSIER_FONDS/$(basename "$f")'" >/dev/null 2>&1
      [ "$paquet" = "$PROJECTIVY" ] && adb push "$f" "/sdcard/Android/data/$PROJECTIVY/files/wallpapers/$(basename "$f")" >/dev/null 2>&1 </dev/null
    done
  fi
  echo "       [OK] $n fonds d'écran envoyés dans le dossier Pictures > FondsEcran."
  tv input keyevent KEYCODE_HOME >/dev/null 2>&1

  echo
  echo " [4/4] Choix du fond d'écran"
  local fonds=() choix fond="" i=0
  for f in "$ICI"/fonds-ecran/*.jpg "$ICI"/fonds-ecran/*.jpeg "$ICI"/fonds-ecran/*.png; do
    [ -f "$f" ] || continue
    fonds+=("$(basename "$f")")
    i=$((i + 1))
    echo "         $i. $(basename "$f")"
  done
  if [ "$i" -gt 0 ]; then
    read -r -p "       Numéro du fond voulu, ou Entrée pour passer : " choix
    case "$choix" in
      '' | *[!0-9]*) ;;
      *) [ "$choix" -ge 1 ] && [ "$choix" -le "$i" ] && fond="${fonds[$((choix - 1))]}" ;;
    esac
  fi
  if [ -n "$fond" ]; then
    echo "       Fond choisi : $fond"
    if [ "$paquet" = "$PROJECTIVY" ]; then # ne laisse que ce fond dans le dossier de Projectivy
      for f in "${fonds[@]}"; do
        [ "$f" = "$fond" ] || tv "rm -f '/sdcard/Android/data/$PROJECTIVY/files/wallpapers/$f'" >/dev/null 2>&1
      done
    fi
    echo "       Tentative d'application automatique..."
    if appliquer_fond "$fond" "$paquet"; then
      echo "       [OK] Ton fond d'écran s'est ouvert dans $nom sur la TV."
      echo "       Regarde la TV : si une confirmation s'affiche, valide-la avec la"
      echo "       télécommande. Si rien n'a changé, voici quoi faire :"
    fi
  fi

  echo
  echo " Dernière étape, sur la TV avec la télécommande :"
  if [ "$paquet" = "$PROJECTIVY" ]; then
    echo "   1. Ouvre les réglages de Projectivy : Apparence > Fond d'écran."
    echo "   2. Choisis « dossier défini par l'utilisateur » : ton fond y est déjà."
    echo "   Ta propre image demande Projectivy Premium. Sans Premium, choisis un"
    echo "   de ses fonds intégrés."
  else
    echo "   1. Ouvre les réglages de $nom, partie fond d'écran."
    echo "   2. Choisis ton image dans Pictures > FondsEcran."
    if [ "$(etat com.lonelycatgames.Xplore)" = absent ]; then
      echo "   Si aucun dossier ne s'ouvre, il faut le gestionnaire de fichiers X-plore."
      if oui "       Ouvrir sa page Play Store sur la TV ?"; then
        tv "am start -a android.intent.action.VIEW -d 'market://details?id=com.lonelycatgames.Xplore'" >/dev/null 2>&1
        echo "       Clique sur Installer sur la TV, puis refais les étapes 1 et 2."
      fi
    fi
  fi
}

ouvrir_image() { # ouvrir_image uri mime paquet [option] -> 0 si l'écran d'accueil a accepté l'image
  local r
  r="$(tv "am start -a android.intent.action.VIEW -t $2 ${4:-} -d '$1' $3" 2>&1)"
  case "$r" in *Error* | *Exception*) return 1 ;; esac
  return 0
}

appliquer_fond() { # ouvre le fond $1 directement dans l'écran d'accueil $2
  local mime="image/jpeg" id
  case "$1" in *.png | *.PNG) mime="image/png" ;; esac
  id="$(tv "content query --uri content://media/external/images/media --projection _id:_display_name | grep -F '_display_name=$1'" 2>/dev/null \
    | tr -d '\r' | sed -n 's/.*_id=\([0-9]*\).*/\1/p' | tail -n 1)"
  if [ -n "$id" ] && ouvrir_image "content://media/external/images/media/$id" "$mime" "$2" --grant-read-uri-permission; then
    return 0
  fi
  ouvrir_image "file://$DOSSIER_FONDS/$1" "$mime" "$2"
}

# --- 5 et 6. Mémoire et restauration -----------------------------------------

memoire() {
  echo
  echo " Analyse en cours, quelques secondes..."
  echo
  tv "dumpsys meminfo | grep -A 12 'Total PSS by process'"
  echo
  echo " Les applis en haut de la liste sont les plus gourmandes."
  echo " Si tu ne t'en sers pas, désinstalle-les depuis les Paramètres de la TV."
}

reactiver() {
  [ "$(etat "$1")" = desactive ] || return 0
  tv pm enable "$1" >/dev/null 2>&1
  echo "       [OK] Réactivée : $2"
}

restaurer_accueil() { # réactive l'écran d'accueil Google $1 s'il est présent et le remet par défaut
  local e
  e="$(etat "$1")"
  [ "$e" = absent ] && return 0
  if [ "$e" = desactive ]; then
    tv pm enable "$1" >/dev/null 2>&1
    echo "       [OK] Écran d'accueil Google réactivé."
  fi
  tv "c=\$(cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME $1 | tail -n 1 | tr -d ' '); case \$c in */*) cmd package set-home-activity \$c;; esac" >/dev/null 2>&1
}

restaurer() {
  echo
  echo " Remet les animations, les applis de la liste, l'écran d'accueil Google"
  echo " et le DNS d'origine. Les fonds d'écran et les applis installées restent."
  oui " Tout remettre comme avant ?" || return 0
  tv settings put global window_animation_scale 1
  tv settings put global transition_animation_scale 1
  tv settings put global animator_duration_scale 1
  echo "       [OK] Animations remises à la vitesse normale."
  pour_chaque_appli reactiver
  restaurer_accueil com.google.android.tvlauncher
  restaurer_accueil com.google.android.leanbacklauncher
  lire_dns
  if [ "$DNS_MODE" = hostname ]; then
    dns_defaut
    echo "       [OK] DNS remis par défaut."
  fi
  echo
  echo " [OK] Annulation terminée."
}

# --- Programme principal -----------------------------------------------------

echo
echo " =========================================================="
echo "       Optimisation d'un TV Stick Android - Xiaomi"
echo " =========================================================="

if [ ! -f "$LISTE" ]; then
  echo
  echo " [ERREUR] Le fichier applis.txt est introuvable."
  echo " Extrais tout le dossier du ZIP avant de lancer ce script."
  exit 1
fi

verifier_adb || exit 1
connecter
infos

while true; do
  echo
  echo " ----------------------------------------------------------"
  echo "  1. Optimiser le stick, recommandé la première fois"
  echo "  2. Nettoyage rapide : vider les caches et la mémoire"
  echo "  3. Wi-Fi : diagnostic, débit réel et DNS anti-pub"
  echo "  4. Écran d'accueil moderne et fonds d'écran"
  echo "  5. Voir ce qui consomme le plus de mémoire"
  echo "  6. Annuler : tout remettre comme avant"
  echo "  7. Quitter"
  echo " ----------------------------------------------------------"
  read -r -p " Ton choix [1-7] : " choix
  case "$choix" in
    1) optimiser ;;
    2) echo; nettoyer ;;
    3) wifi ;;
    4) accueil ;;
    5) memoire ;;
    6) restaurer ;;
    7) fin 0 ;;
  esac
done
