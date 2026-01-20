# TP Tomographie Ultrasonore - Réponses Succinctes

## Partie 1 : Mise en place et acquisition de la matrice A-scan

### Question 1 : Justifier le choix de translater l'objet pour réaliser l'A-scan

**Réponse :**
- Simplification mécanique : déplacer le petit objet est plus simple et précis que déplacer tout le système émetteur-récepteur
- Stabilité géométrique : capteur fixe garantit l'alignement constant entre émetteur et récepteur, réduisant les erreurs
- Géométrie parallèle : la translation de l'objet assure que toutes les lignes de projection restent parallèles, condition requise pour la tomographie en faisceau parallèle
- Rentabilité : système mécanique pour déplacer l'objet est plus économique
- Calibration facilitée : position fixe du transducteur facilite la maintenance de la calibration

---

### Question 2 : À quoi sert le gel ? Si le gel est mal réparti, quels problèmes peut-on rencontrer ?

**Réponse :**

**Rôle du gel :**
- Adaptation d'impédance : réduit le saut d'impédance acoustique à l'interface air/solide
- Élimination des espaces d'air : remplit les micro-espaces entre le transducteur et la paroi du bac
- Réduction des pertes par réflexion : l'interface air réfléchit 99,9% de l'énergie ultrasonore
- Amélioration du couplage : assure une transmission efficace de l'énergie acoustique

**Problèmes si le gel est mal réparti :**
- Intensité du signal non uniforme, création d'artéfacts
- Erreurs systématiques dans l'extraction du coefficient d'atténuation
- Dégradation sévère de la qualité du signal à certaines positions
- Qualité d'image de reconstruction non homogène

---

### Question 3 : Si la largeur du bac est de 14 cm (vitesse du son dans l'eau = 1500 m/s), calculer le temps d'arrivée théorique du signal émis

**Calcul :**
```
t = d / c = 0,14 m / 1500 m/s = 93,3 μs
```

**Réponse : 93,3 microsecondes**

---

### Question 4 : Calculer le nombre N d'acquisitions à effectuer pour créer la matrice A-scan (diamètre échantillon 60mm, pas 5mm)

**Calcul :**
```
N = (60 mm / 5 mm) + 1 = 13
```

**Réponse : 13 acquisitions**

---

## Partie 2 : Lecture de la matrice A-scan sous Matlab et extraction des observables de la tomographie

### Question 5 : Afficher la matrice A-scan et son enveloppe (en dB)

**Méthode :**
1. Lire tous les fichiers de signaux et construire la matrice
2. Calculer l'enveloppe : `envelope = abs(hilbert(signal))`
3. Convertir en dB : `envelope_dB = 20*log10(envelope)`
4. Afficher avec `imagesc()`

**Description des résultats expérimentaux :**

Nous avons utilisé deux méthodes de visualisation :
- **Affichage 2D** : avec `imagesc`, les 13 acquisitions sont affichées sous forme d'image couleur, l'axe horizontal représente les points d'échantillonnage temporel, l'axe vertical représente les positions de translation
- **Affichage 1D comparatif** : les 13 acquisitions sont affichées individuellement, le signal RF à gauche et son enveloppe correspondante à droite

On observe clairement que le temps d'arrivée du signal est d'environ 93 μs, et l'atténuation du signal est notable dans la zone de l'objet.

---

### Question 6a : Proposer une grandeur observable à partir du signal temporel brut de l'A-scan qui représente le terme d'atténuation ∫μ(x,y)dl

**Réponse :**

Selon la formule d'atténuation des ondes acoustiques : A = A₀ exp(-∫μ(x,y)dl)

En prenant le logarithme : ∫μ(x,y)dl = ln(A₀/A)

**Grandeur observable :**
- **Observable = -ln(A_reçue / A_référence)**
- Ou **Observable = ln(A₀ / A)**

Où :
- A_reçue : amplitude du signal reçu après traversée de l'objet (pic de l'enveloppe)
- A_référence : amplitude de référence (signal sans objet)

**Implémentation pratique** : extraire le maximum de l'enveloppe de chaque A-scan, comparer avec la valeur de référence et calculer le logarithme du rapport

---

### Question 6b : Extraire l'amplitude et comparer avec GS-EchoView

**Méthode :**
1. Extraire l'amplitude maximale ou le pic de l'enveloppe de chaque A-scan
2. Convertir en dB : `amp_dB = 20*log10(amp)`
3. Comparer graphiquement avec `amp_extraites`
4. Calculer l'erreur moyenne et l'écart-type

**Description des résultats expérimentaux :**

- On prend le maximum de chaque acquisition pour constituer le vecteur A
- On effectue une acquisition à vide, dont le maximum sert de référence A₀
- Le logiciel du constructeur utilise par défaut A₀=1 comme référence

**Description du graphique comparatif :** Le graphique montre deux courbes :
- **Courbe 1** : nos résultats de mesure expérimentale
- **Courbe 2** : les données du logiciel constructeur

Les deux courbes ont la même tendance, mais présentent un **décalage vertical (offset)** constant, dû au choix différent de la valeur de référence A₀.

---

## Partie 3 : Enregistrement des amplitudes avec GS-EchoView et réalisation de la tomographie

### Question 7 : L'objet effectue un tour complet, calculer le nombre R de rotations à effectuer (pas angulaire 16,2°)

**Calcul :**
```
R = 360° / 16,2° = 22,22
```

Réponse : 23 rotations

---

### Question 8 : Quel effet aurait l'utilisation d'un plus grand nombre d'angles ?

**Réponse :**

**Effets positifs :**
- Amélioration de la résolution angulaire, réduction des artéfacts de stries
- Amélioration de la qualité d'image, contours plus nets
- Meilleure capacité de détection des petites structures
- Réduction des effets de sous-échantillonnage

**Effets négatifs :**
- Augmentation du temps d'acquisition et du volume de données
- Accumulation possible de bruit de mesure

**Conclusion :** Un plus grand nombre d'angles améliore significativement la qualité de reconstruction mais nécessite un compromis avec le temps d'acquisition

---

### Question 9 : Calculer le nombre total de mesures de la tomographie (23 rotations, pas translation 2mm, longueur scan 60mm)

**Calcul :**
```
Nombre d'acquisitions par rotation : N = 60/2 + 1 = 31
Nombre total de mesures = 23 × 31 = 713
```

**Réponse : 713 mesures**

---

### Question 10 : Commenter les résultats obtenus

**Description des résultats expérimentaux :**

Dans l'image reconstruite, on observe que l'intérieur de l'objet cylindrique présente **3 zones distinctes**, chacune ayant un degré d'atténuation différent des ultrasons. Cela indique que l'objet est composé de différents matériaux ayant des propriétés acoustiques différentes.

**Points d'évaluation :**
- Précision géométrique : diamètre de l'objet environ 60mm, forme correcte
- Structure interne : 3 zones d'atténuation différentes clairement visibles
- Analyse des artéfacts : 23 angles produisent de légers artéfacts de stries
- Suggestions d'amélioration : augmenter la densité d'échantillonnage angulaire et de translation

---

### Question 11 : Comment obtenir un meilleur résultat de tomographie ?

**Réponse :**

**1. Optimisation des paramètres d'échantillonnage :**
- Augmenter le nombre d'angles (de 23 à 180 ou plus)
- Réduire le pas de translation (de 2mm à 1mm ou 0,5mm)
- Augmenter la fréquence d'échantillonnage temporel

**2. Amélioration matérielle :**
- Utiliser un transducteur de fréquence plus élevée
- Améliorer la précision d'alignement et la stabilité mécanique
- Assurer une application uniforme du gel

**3. Traitement du signal :**
- Filtrage de débruitage
- Moyennage de signaux pour réduire le bruit aléatoire
- Contrôle automatique de gain

**4. Algorithme de reconstruction :**
- Utiliser la rétroprojection filtrée (FBP)
- Choisir un filtre approprié (Shepp-Logan, Hamming, etc.)
- Utiliser des algorithmes de reconstruction itérative (ART, SART)

**5. Calibration et compensation :**
- Calibration géométrique pour déterminer le centre de rotation
- Compensation de l'atténuation de l'eau
- Correction du durcissement de faisceau

---

## Partie 4 : Tomographie sous Matlab

### Question 12 : Afficher la matrice des grandeurs observables

**Méthode :**
- Sinogramme : matrice 31×23
- Chaque colonne correspond à une projection à un angle donné
- Afficher avec `imagesc(sinogram)`

**Description des résultats expérimentaux :**

La matrice d'acquisition affichée avec `imagesc` est de **31 lignes × 23 colonnes** :
- 31 lignes correspondent aux 31 positions de translation différentes
- 23 colonnes correspondent aux 23 angles de rotation différents

L'image présente les caractéristiques typiques d'un sinogramme, où la position de projection de l'objet varie sinusoïdalement avec l'angle de rotation. On observe des bandes de luminosité différentes, reflétant l'effet de superposition des projections des 3 zones d'atténuation différentes à chaque angle.

---

### Question 13 : Réaliser la tomographie avec la fonction iradon et comparer

**Méthode :**
```matlab
theta = 0:16.2:(23-1)*16.2;
reconstruction = iradon(sinogram, theta, 'Shepp-Logan', 'spline', size(sinogram,1));
```

**Description des résultats expérimentaux :**

En utilisant `iradon` pour effectuer la transformée de Radon inverse, on reconstruit l'image tomographique et on retrouve avec succès les **3 zones d'atténuation** à l'intérieur de l'objet.

**Comparaison des différentes interpolations et filtres :**

1. **Interpolation linéaire (par défaut)** : l'image reconstruite montre clairement les 3 zones d'atténuation, les frontières sont identifiables

2. **Interpolation spline** : le résultat est très proche de l'interpolation linéaire, les transitions sont plus lisses, mais la différence globale est minime

3. **Filtre Shepp-Logan** : par rapport au filtre par défaut, ce filtre permet de **mieux séparer les différentes zones**, les frontières sont plus nettes et plus précises

**Conclusion :** Le filtrage affecte la conservation des informations de contour. Le filtre Shepp-Logan donne de meilleurs résultats pour la séparation des zones, mais peut entraîner une perte de certains détails de contour.
