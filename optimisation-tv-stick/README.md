# Rendre ton TV Stick Android plus fluide

Script pour accélérer un **Xiaomi Mi TV Stick** (ou Xiaomi TV Stick 4K, Mi Box, et la plupart des boîtiers Android TV).
Il se lance depuis ton ordinateur et parle au stick par le Wi-Fi grâce à **ADB**, l'outil officiel de Google pour piloter Android.

- Pas de root, rien n'est supprimé, tout est réversible (option 4 du menu).
- Le seul téléchargement fait par le script, c'est ADB, depuis le site de Google, la première fois.

## Ce que fait le script

| Étape | Effet |
| --- | --- |
| Animations accélérées (×0,5) | Les menus répondent deux fois plus vite. C'est le changement le plus visible. |
| Désactivation d'applis, **au choix** | Le script te demande pour chaque appli. Celles que tu désactives ne tournent plus en arrière-plan et libèrent de la mémoire. |
| Nettoyage | Vide les caches de toutes les applis et ferme celles qui tournent en fond. Ça libère du stockage. |
| Compilation des applis (optionnelle) | Les applis s'ouvrent plus vite. C'est l'entretien qu'Android fait normalement la nuit, ici lancé tout de suite. |
| Redémarrage | Applique tout proprement. |

## 1. Préparer le stick (une seule fois, 5 minutes)

Avec la télécommande :

1. **Débloquer les options pour les développeurs** : *Paramètres → Préférences de l'appareil → À propos*, puis clique **7 fois** sur **Build**. Le message « Vous êtes maintenant développeur » s'affiche.
2. **Activer le débogage** : *Paramètres → Préférences de l'appareil → Options pour les développeurs → Débogage USB → Activé*. Il s'appelle « USB » mais il marche aussi en Wi-Fi.
3. **Noter l'adresse IP du stick** : *Paramètres → Réseau et Internet*, puis clique sur ton réseau Wi-Fi. Note l'**adresse IP**, par exemple `192.168.1.42`.

L'ordinateur doit être connecté à **la même box** que le stick.

## 2. Lancer le script

**Windows** : extrais le ZIP, puis double-clique sur **`optimiser-tv.bat`**.
Si Windows affiche « Windows a protégé votre ordinateur », clique sur *Informations complémentaires → Exécuter quand même*.

**Mac / Linux** : ouvre un Terminal dans le dossier et tape `bash optimiser-tv.sh`.

Le script te demande l'adresse IP. Ensuite, **regarde la TV** : une fenêtre « Autoriser le débogage USB ? » s'affiche. Coche **Toujours autoriser depuis cet ordinateur** et choisis **OK**.

## 3. Le menu

```
 1. Optimiser le stick, recommandé la première fois
 2. Nettoyage rapide : vider les caches et la mémoire
 3. Voir ce qui consomme le plus de mémoire
 4. Annuler : tout réactiver et remettre les animations
 5. Quitter
```

- La première fois, prends **1**.
- Ensuite, un **2** de temps en temps (une fois par mois par exemple) suffit.
- **3** liste les applis qui prennent le plus de mémoire, pratique pour repérer les gourmandes.
- **4** réactive toutes les applis de la liste et remet les animations normales.

## Quelles applis désactiver ?

Le script ne propose que les applis présentes sur ton stick. YouTube et le Play Store ne sont jamais touchés.

| Appli | Désactive-la si… | Ce que tu perds |
| --- | --- | --- |
| Mode Ambiant | presque toujours | l'écran de veille avec photos |
| Google Play Jeux | toujours | rien d'utile sur une TV |
| Google Play Films et TV | tu n'as pas acheté de films chez Google | l'accès aux films achetés chez Google |
| YouTube Kids, YouTube Music, Prime Video, Netflix, Spotify | tu ne t'en sers **pas** | l'appli en question (sinon, garde-la) |
| Chromecast intégré | tu ne castes jamais depuis ton téléphone | le bouton « Caster » des applis du téléphone |
| Assistant Google | tu n'utilises pas le bouton micro | la recherche vocale. C'est l'appli qui libère le plus de mémoire. |

## 4. Les réglages à faire à la main

Ils ne demandent pas d'ordinateur, et certains comptent autant que le script :

1. **Couper les aperçus sur l'écran d'accueil** : *Paramètres → Préférences de l'appareil → Écran d'accueil*, désactive **l'aperçu vidéo** et **l'aperçu audio**. Dans **Chaînes**, désactive celles des applis que tu ne regardes pas. Les vidéos qui se lancent toutes seules sur l'accueil sont une grosse source de lenteur.
2. **Garder au moins 1 Go de stockage libre** : *Paramètres → Préférences de l'appareil → Stockage*. Sur le stick de 8 Go, un stockage plein est souvent **la** cause des ralentissements. Désinstalle ce que tu n'utilises pas.
3. **Mises à jour du Play Store** : dans le Play Store, *Paramètres → Mise à jour automatique des applis → Ne pas mettre à jour automatiquement*. Les mises à jour en fond ralentissent beaucoup un petit stick. Pense quand même à les faire toi-même une fois par mois (*Play Store → Mes applis*).
4. **Alimentation** : branche le câble sur **l'adaptateur secteur**, pas sur le port USB de la TV. Ce port donne souvent trop peu de courant : le stick ralentit, plante ou redémarre tout seul.
5. **Wi-Fi** : utilise le réseau **5 GHz** de ta box si tu peux. Une petite rallonge HDMI pour sortir le stick de derrière la TV améliore beaucoup le signal.
6. **Redémarrer de temps en temps** : le stick ne s'éteint jamais vraiment, il se met en veille. Un redémarrage par semaine libère la mémoire : *Paramètres → Préférences de l'appareil → À propos → Redémarrer*.
7. **Optionnel, un lanceur plus léger** : *Projectivy Launcher* (sur le Play Store) remplace l'écran d'accueil par un plus simple, sans publicités ni recommandations.

## Dépannage

| Problème | Solution |
| --- | --- |
| « Impossible de se connecter » | Vérifie que le PC et le stick sont sur la même box et que l'IP n'a pas changé. Elle peut changer quand la box redémarre. Vérifie aussi que *Débogage USB* est toujours activé. |
| La fenêtre d'autorisation n'apparaît pas sur la TV | *Options pour les développeurs → Révoquer les autorisations de débogage USB*, puis relance le script. |
| Ton stick n'a que « Débogage sans fil » (modèles récents) | Dans le script, choisis **[A] Associer avec un code** et suis les instructions. |
| « Ce modèle refuse de la désactiver » | C'est normal pour certaines applis système : rien n'est cassé, le script passe à la suite. |
| Quelque chose ne marche plus | Relance le script et choisis **4**. |

## Sécurité

Quand tu as fini, tu peux **désactiver le Débogage USB** dans les options pour les développeurs. Tu le réactiveras le jour où tu voudras relancer le script.

## À quoi t'attendre

Les menus seront nettement plus réactifs, les applis s'ouvriront plus vite et le stick se bloquera moins souvent.
Le Mi TV Stick reste un petit appareil avec 1 Go de mémoire. Si une appli de streaming rame encore après tout ça, c'est la limite du matériel. La vraie solution serait alors un modèle avec au moins 2 Go de mémoire.

## Fichiers

- `optimiser-tv.bat` : le script pour Windows
- `optimiser-tv.sh` : le script pour Mac et Linux
- `applis.txt` : la liste des applis proposées. Tu peux la modifier.
