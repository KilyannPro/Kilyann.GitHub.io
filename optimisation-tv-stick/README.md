# Rendre ton TV Stick Android plus fluide et plus beau

Script pour accélérer un **Xiaomi Mi TV Stick** (ou Xiaomi TV Stick 4K, Mi Box, et la plupart des boîtiers Android TV), améliorer son Wi-Fi et lui donner un écran d'accueil propre avec fond d'écran.
Il se lance depuis ton ordinateur et parle au stick par le Wi-Fi grâce à **ADB**, l'outil officiel de Google pour piloter Android.

- Pas de root, rien n'est supprimé, tout est réversible (option 6 du menu).
- Le seul téléchargement fait par le script, c'est ADB, depuis le site de Google, la première fois.

## Le menu

```
 1. Optimiser le stick, recommandé la première fois
 2. Nettoyage rapide : vider les caches et la mémoire
 3. Wi-Fi : diagnostic, débit réel et DNS anti-pub
 4. Écran d'accueil moderne et fonds d'écran
 5. Voir ce qui consomme le plus de mémoire
 6. Annuler : tout remettre comme avant
 7. Quitter
```

| Option | Ce qu'elle fait |
| --- | --- |
| **1. Optimiser** | Accélère les animations (×0,5), te propose de désactiver les applis qui tournent en fond, vide les caches, compile les applis pour qu'elles s'ouvrent plus vite, puis redémarre. |
| **2. Nettoyage rapide** | Vide les caches et ferme les applis en fond. À refaire une fois par mois. |
| **3. Wi-Fi** | Analyse la connexion, mesure le vrai débit, te donne des conseils adaptés et propose un DNS qui bloque une partie des pubs. |
| **4. Écran d'accueil** | Installe un écran d'accueil plus propre et plus léger, le met par défaut et envoie les fonds d'écran sur la TV. |
| **5. Mémoire** | Liste les applis qui prennent le plus de mémoire. |
| **6. Annuler** | Remet les animations, les applis, l'écran d'accueil Google et le DNS d'origine. |

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

La première fois, prends l'option **1**, puis la **4** pour l'écran d'accueil et la **3** pour le Wi-Fi.

## Quelles applis désactiver ? (option 1)

Le script ne propose que les applis présentes sur ton stick. YouTube et le Play Store ne sont jamais touchés.

| Appli | Désactive-la si… | Ce que tu perds |
| --- | --- | --- |
| Mode Ambiant | presque toujours | l'écran de veille avec photos |
| Google Play Jeux | toujours | rien d'utile sur une TV |
| Google Play Films et TV | tu n'as pas acheté de films chez Google | l'accès aux films achetés chez Google |
| YouTube Kids, YouTube Music, Prime Video, Netflix, Spotify | tu ne t'en sers **pas** | l'appli en question (sinon, garde-la) |
| Chromecast intégré | tu ne castes jamais depuis ton téléphone | le bouton « Caster » des applis du téléphone |
| Assistant Google | tu n'utilises pas le bouton micro | la recherche vocale. C'est l'appli qui libère le plus de mémoire. |

## Le Wi-Fi (option 3)

Le script affiche :

- **la bande** : 2,4 GHz ou 5 GHz. En 2,4 GHz, le stick est plus lent et se partage les ondes avec la télécommande Bluetooth. Passer en 5 GHz est le plus gros gain possible.
- **la force du signal** : excellent, bon, moyen ou faible.
- **le débit réel**, mesuré en envoyant 8 Mo au stick. Repères : 10 Mbit/s pour la HD, 25 Mbit/s pour la 4K. Si ton ordinateur est lui aussi en Wi-Fi, le vrai débit du stick est sans doute plus élevé.

Il te donne ensuite des conseils adaptés à ton résultat.

**DNS anti-pub (optionnel)** : il utilise AdGuard DNS, gratuit, pour bloquer une partie des pubs et des traqueurs dans les applis et sur l'écran d'accueil. Les pubs YouTube ne sont pas bloquées. Le script vérifie qu'Internet marche toujours après le changement. Si ta box bloque ce type de DNS, il annule tout seul.

**Ce qui aide le plus, à faire toi-même :**

1. **Passer en 5 GHz** : si ta box n'affiche qu'un seul réseau, sépare les bandes 2,4 et 5 GHz dans son interface, puis connecte le stick au réseau 5 GHz.
2. **Sortir le stick de derrière la TV** avec une petite rallonge HDMI, à quelques euros. La TV fait écran aux ondes.
3. **Bien placer la box** : en hauteur, hors d'un meuble fermé, loin des autres appareils sans fil.
4. **Changer de canal Wi-Fi** dans l'interface de la box, si les coupures arrivent surtout le soir.
5. **Ethernet** : c'est la solution la plus fiable, mais le stick n'a pas de prise réseau. Certains utilisateurs passent par un adaptateur USB-Ethernet avec un câble OTG alimenté. Vérifie que ton modèle le gère avant d'acheter.

## Écran d'accueil et fonds d'écran (option 4)

L'écran d'accueil d'origine d'Android TV n'accepte **pas** de fond d'écran et affiche beaucoup de publicités. Le script t'aide à le remplacer :

| Écran d'accueil | Points forts | Ta propre image en fond |
| --- | --- | --- |
| **Projectivy Launcher** | Le plus beau et le plus réglable. Il a ses propres fonds d'écran. | Avec la version Premium, payante |
| **FLauncher** | Simple, gratuit et open source | Gratuit, avec un gestionnaire de fichiers comme X-plore |

Le script :

1. ouvre directement la page Play Store de celui que tu choisis sur la TV ;
2. le met comme écran d'accueil par défaut ;
3. te propose de désactiver l'écran d'accueil Google : le bouton Accueil n'y ramène plus, et ça libère beaucoup de mémoire ;
4. envoie les fonds d'écran dans le dossier *Pictures → FondsEcran* du stick, et dans le dossier de Projectivy s'il est installé.

**Les 6 fonds d'écran fournis** (dossier `fonds-ecran`, 1920×1080) : Aurore, Crépuscule, Océan, Minuit, Dunes et Ardoise. Ils sont sombres pour que les icônes restent lisibles, avec un léger grain qui évite les bandes de couleur sur les TV.
Pour ajouter tes propres images, mets-les dans le dossier `fonds-ecran` (JPG ou PNG) et relance l'option 4.

**Choisir le fond d'écran sur la TV** :

- *Projectivy* : dans ses réglages, *Apparence → Fond d'écran*. Sans Premium, prends un de ses fonds intégrés. Avec Premium, choisis le dossier défini par l'utilisateur : les images y sont déjà copiées.
- *FLauncher* : dans ses réglages, partie fond d'écran, choisis une image dans *Pictures → FondsEcran*.

## Les autres réglages à faire à la main

1. **Couper les aperçus** (si tu gardes l'écran d'accueil Google) : *Paramètres → Préférences de l'appareil → Écran d'accueil*, désactive **l'aperçu vidéo** et **l'aperçu audio**, et les **Chaînes** des applis que tu ne regardes pas.
2. **Garder au moins 1 Go de stockage libre** : *Paramètres → Préférences de l'appareil → Stockage*. Sur le stick de 8 Go, un stockage plein est souvent **la** cause des ralentissements.
3. **Mises à jour du Play Store** : dans le Play Store, *Paramètres → Mise à jour automatique des applis → Ne pas mettre à jour automatiquement*, puis fais-les toi-même une fois par mois.
4. **Alimentation** : branche le câble sur **l'adaptateur secteur**, pas sur le port USB de la TV, qui donne souvent trop peu de courant.
5. **Redémarrer une fois par semaine** : *Paramètres → Préférences de l'appareil → À propos → Redémarrer*.

## Dépannage

| Problème | Solution |
| --- | --- |
| « Impossible de se connecter » | Vérifie que l'ordinateur et le stick sont sur la même box et que l'IP n'a pas changé. Vérifie aussi que *Débogage USB* est toujours activé. |
| La fenêtre d'autorisation n'apparaît pas sur la TV | *Options pour les développeurs → Révoquer les autorisations de débogage USB*, puis relance le script. |
| Ton stick n'a que « Débogage sans fil » (modèles récents) | Dans le script, choisis **[A] Associer avec un code**. |
| Le bouton Accueil ramène à l'écran Google | Relance l'option 4 et accepte de désactiver l'écran d'accueil Google. Si ton modèle refuse, active dans les réglages de ton nouvel écran d'accueil l'option qui remplace le lanceur actuel. |
| FLauncher ne trouve pas les images | Installe le gestionnaire de fichiers **X-plore** depuis le Play Store et réessaie. |
| « Ce modèle refuse de la désactiver » | C'est normal pour certaines applis système : rien n'est cassé. |
| Quelque chose ne marche plus | Relance le script et choisis **6**. |

## Sécurité

Quand tu as fini, tu peux **désactiver le Débogage USB** dans les options pour les développeurs. Tu le réactiveras le jour où tu voudras relancer le script.

## À quoi t'attendre

Les menus seront nettement plus réactifs, les applis s'ouvriront plus vite et le stick se bloquera moins souvent. Remplacer l'écran d'accueil Google est ce qui libère le plus de mémoire.
Le Mi TV Stick reste un petit appareil avec 1 Go de mémoire. Si une appli de streaming rame encore après tout ça, c'est la limite du matériel.

## Fichiers

- `optimiser-tv.bat` : le script pour Windows
- `optimiser-tv.sh` : le script pour Mac et Linux
- `applis.txt` : la liste des applis proposées. Tu peux la modifier.
- `fonds-ecran/` : les fonds d'écran envoyés sur la TV. Tu peux y ajouter les tiens.
