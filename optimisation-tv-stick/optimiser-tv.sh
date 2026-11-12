#!/usr/bin/env bash
# ============================================================
#  Optimisation d'un TV Stick Android (Xiaomi Mi TV Stick...)
#  Version macOS / Linux. Lancement : bash optimiser-tv.sh
#  Tout passe par ADB, l'outil officiel de Google.
#  Aucun root, rien d'irréversible : l'option 4 du menu annule tout.
# ============================================================
set -u

ICI="$(cd "$(dirname "$0")" && pwd)"
LISTE="$ICI/applis.txt"
export PATH="$ICI/platform-tools:$PATH"

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

# --- Actions -----------------------------------------------------------------

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
  if tv pm disable-user --user 0 "$1" 2>/dev/null | grep -q disabled; then
    echo "         [OK] Désactivée."
  else
    echo "         [!] Ce modèle refuse de la désactiver, on passe à la suite."
  fi
}

reactiver() {
  [ "$(etat "$1")" = desactive ] || return 0
  tv pm enable "$1" >/dev/null 2>&1
  echo "       [OK] Réactivée : $2"
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
  echo "       Rien n'est supprimé, l'option 4 du menu les réactive."
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

memoire() {
  echo
  echo " Analyse en cours, quelques secondes..."
  echo
  tv "dumpsys meminfo | grep -A 12 'Total PSS by process'"
  echo
  echo " Les applis en haut de la liste sont les plus gourmandes."
  echo " Si tu ne t'en sers pas, désinstalle-les depuis les Paramètres de la TV."
}

restaurer() {
  echo
  oui " Réactiver toutes les applis de la liste et remettre les animations normales ?" || return 0
  tv settings put global window_animation_scale 1
  tv settings put global transition_animation_scale 1
  tv settings put global animator_duration_scale 1
  echo "       [OK] Animations remises à la vitesse normale."
  pour_chaque_appli reactiver
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
  echo "  3. Voir ce qui consomme le plus de mémoire"
  echo "  4. Annuler : tout réactiver et remettre les animations"
  echo "  5. Quitter"
  echo " ----------------------------------------------------------"
  read -r -p " Ton choix [1-5] : " choix
  case "$choix" in
    1) optimiser ;;
    2) echo; nettoyer ;;
    3) memoire ;;
    4) restaurer ;;
    5) fin 0 ;;
  esac
done
