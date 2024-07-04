# Législatives 2024

Résultats des élections législatives françaises 2024 : données géolocalisées et réordonnées, analyses statistiques, cartographies.

## Données :

- [Résultats provisoires du 1er tour - Ministère de l'Intérieur et des Outre-Mer](https://www.data.gouv.fr/fr/datasets/elections-legislatives-des-30-juin-et-7-juillet-2024-resultats-provisoires-du-1er-tour/)
- [Coordonnées géographiques des circonscriptions - INSEE](https://www.insee.fr/fr/statistiques/6441661?sommaire=6436478)

Résultats de 558 circonscriptions françaises, données manquantes pour les 11 circonscriptions de l'étranger et les 8 circonscriptions des Collectivités d'Outre-mer.

## Méthode :

- Jointure des résultats avec les données géolocalisées via le code de circonscription.
- Réordonnançement des données avec PostgreSQL (renommage et retypage des champs, création d'une ligne par candidat·e, etc.) (cf. preparation_des_donnees)
- Attribution d'un bloc politique à chacune des 24 nuances [définies par le Ministère de l'Intérieur](https://www.resultats-elections.interieur.gouv.fr/legislatives2024/referentiel.html)y

| Nuance définie par le Ministère de l'Intérieur et de l'Outre-mer | Bloc politique de rattachement défini subjectivement par mes soins |
| ---------------------------------------------------------------- | ------------------------------------------------------------------ |
| EXG                                                              | extrême-gauche                                                     |
| UG                                                               | gauche                                                             |
| FI                                                               | gauche                                                             |
| ECO                                                              | gauche                                                             |
| SOC                                                              | gauche                                                             |
| DVG                                                              | gauche                                                             |
| COM                                                              | gauche                                                             |
| VEC                                                              | gauche                                                             |
| RDG                                                              | gauche                                                             |
| REN                                                              | centre                                                             |
| ENS                                                              | centre                                                             |
| MDM                                                              | centre                                                             |
| HOR                                                              | centre                                                             |
| DVC                                                              | centre                                                             |
| UDI                                                              | centre                                                             |
| LR                                                               | droite                                                             |
| DVD                                                              | droite                                                             |
| DSV                                                              | extrême-droite                                                     |
| RN                                                               | extrême-droite                                                     |
| REC                                                              | extrême-droite                                                     |
| UXD                                                              | extrême-droite                                                     |
| EXD                                                              | extrême-droite                                                     |
| DIV                                                              | divers                                                             |
| REG                                                              | divers                                                             |

## [Données mises à disposition :](donnees_produites/)

- résultats du 1er tour des élections législatives, circonscription par circonscription (fichiers géolocalisés)
- résultats du 1er tour des élections législatives, candidat·e par candidat·e (un fichier géolocalisés, un fichier CSV)
- statistiques genrées :
  - Répartition des positions (qualifiable, élu-e) après le premier tour selon le département, la nuance et le bloc politique
  - Nombre de voix moyen et médian, taux de votes par rapport au nombre d'inscriptions et de votes exprimés, par département, nuance et bloc politique

Données également téléchargeables sur [data.gouv.fr](https://www.data.gouv.fr/fr/datasets/resultats-provisoires-des-elections-legislatives-francaises-2024-donnees-geolocalisees/)

Visualisations interactives disponibles sur Flourish : https://app.flourish.studio/@idrissad

Images disponibles dans le dossier [visualisations](/visualisations)

## Chiffres-clefs :

### Répartition genrée des candidat·es au premier tour par bloc politique :
![Répartition genrée des candidat·es par bloc politique](/visualisations/Répartition%20genrée%20par%20bloc%20politique%20-%20candidat-es.png)

### Répartition genrée des candidat·es arrivé·es en première position du premier tour par bloc politique :
![Répartition genrée des candidat·es arrivé·es en première position du premier tour par bloc politique](/visualisations/Répartition%20genrée%20par%20bloc%20politique%20-%20première%20position.png)


## Statistiques :

## Cartographies :
