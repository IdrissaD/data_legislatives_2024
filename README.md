# Législatives 2024
Résultats des élections législatives françaises 2024 : données géolocalisées et réordonnées, analyses statistiques, cartographies.

## Données :
- [Résultats provisoires du 1er tour - Ministère de l'Intérieur et des Outre-Mer](https://www.data.gouv.fr/fr/datasets/elections-legislatives-des-30-juin-et-7-juillet-2024-resultats-provisoires-du-1er-tour/)
- [Coordonnées géographiques des circonscriptions - INSEE](https://www.insee.fr/fr/statistiques/6441661?sommaire=6436478)

## Résultats de 558 circonscriptions françaises, données manquantes pour les 11 circonscriptions de l'étranger et les 8 circonscriptions des Collectivités d'Outre-mer.

## Méthode :
- Jointure des résultats avec les données géographiques via le code de circonscription.
- Réordonnançement des données avec PostgreSQL (renommage et retypage des champs, création d'une ligne par candidat·e, etc.) (cf. preparation_des_donnees)
- Attribution d'un bloc politique à chacune des 24 nuances [définies par le Ministère de l'Intérieur](https://www.resultats-elections.interieur.gouv.fr/legislatives2024/referentiel.html)

## Données mises à disposition :
- liste de chacun·e des candidat·es avec ses résultats, sa position au 1er tour, ainsi que les chiffres généraux de la circonscription
- la même liste, avec les géométries de chaque circonscription

## Chiffres-clefs :

## Statistiques :

## Cartographies :
