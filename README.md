Projet de mise à disposition de données ordonnées, de chiffres-clefs et de visualisations inédites sur les élections législatives françaises anticipées de 2024.

## Visualisations :

Si vous consultez ce README depuis GitHub, cliquez [ici](https://idrissad.github.io/legislatives_2024/) pour avoir accès aux visualisations interactives.

<div class="flourish-embed flourish-chart" data-src="visualisation/18623753"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

<div class="flourish-embed flourish-chart" data-src="visualisation/18624186"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

## Données source :

- [Résultats provisoires du 1er tour - Ministère de l'Intérieur et des Outre-Mer](https://www.data.gouv.fr/fr/datasets/elections-legislatives-des-30-juin-et-7-juillet-2024-resultats-provisoires-du-1er-tour/)
- [Coordonnées géographiques des circonscriptions - INSEE](https://www.insee.fr/fr/statistiques/6441661?sommaire=6436478)

Résultats de 558 circonscriptions françaises, données manquantes pour les 11 circonscriptions de l'étranger et les 8 circonscriptions des Collectivités d'Outre-mer.

## Méthode :

- Jointure des résultats avec les données géolocalisées via le code de circonscription.
- Réordonnançement des données avec PostgreSQL (renommage et retypage des champs, création d'une ligne par candidat·e, etc.) (cf. [preparation_des_donnees.sql](https://github.com/IdrissaD/legislatives_2024/requetes_sql/))
- Attribution d'un bloc politique à chacune des 24 nuances [définies par le Ministère de l'Intérieur](https://www.resultats-elections.interieur.gouv.fr/legislatives2024/referentiel.html)

<details>
  <summary><b>Nuances et leur regroupement par bloc politique</b></summary>
  
  <table><thead><tr><th>Nuance définie par le Ministère de l'Intérieur et de l'Outre-mer</th><th>Bloc politique de rattachement défini subjectivement par mes soins</th></tr></thead><tbody><tr><td>EXG</td><td>extrême-gauche</td></tr><tr><td>UG</td><td>gauche</td></tr><tr><td>FI</td><td>gauche</td></tr><tr><td>ECO</td><td>gauche</td></tr><tr><td>SOC</td><td>gauche</td></tr><tr><td>DVG</td><td>gauche</td></tr><tr><td>COM</td><td>gauche</td></tr><tr><td>VEC</td><td>gauche</td></tr><tr><td>RDG</td><td>gauche</td></tr><tr><td>REN</td><td>centre</td></tr><tr><td>ENS</td><td>centre</td></tr><tr><td>MDM</td><td>centre</td></tr><tr><td>HOR</td><td>centre</td></tr><tr><td>DVC</td><td>centre</td></tr><tr><td>UDI</td><td>centre</td></tr><tr><td>LR</td><td>droite</td></tr><tr><td>DVD</td><td>droite</td></tr><tr><td>DSV</td><td>extrême-droite</td></tr><tr><td>RN</td><td>extrême-droite</td></tr><tr><td>REC</td><td>extrême-droite</td></tr><tr><td>UXD</td><td>extrême-droite</td></tr>
<tr><td>EXD</td><td>extrême-droite</td></tr><tr><td>DIV</td><td>divers</td></tr><tr><td>REG</td><td>divers</td></tr></tbody></table>  
</details>


## Données produites :

- résultats du 1er tour des élections législatives, circonscription par circonscription (fichiers géolocalisés)
- résultats du 1er tour des élections législatives, candidat·e par candidat·e (un fichier géolocalisés, un fichier CSV)
- statistiques genrées :
  - Répartition des positions (qualifiable, élu-e) après le premier tour selon le département, la nuance et le bloc politique
  - Nombre de voix moyen et médian, taux de votes par rapport au nombre d'inscriptions et de votes exprimés, par département, nuance et bloc politique

Données téléchargeables sur [data.gouv.fr](https://www.data.gouv.fr/fr/datasets/resultats-provisoires-des-elections-legislatives-francaises-2024-donnees-geolocalisees/) et [GitHub](https://github.com/IdrissaD/legislatives_2024/donnees_produites)

Visualisations interactives disponibles sur Flourish : https://app.flourish.studio/@idrissad

Images disponibles dans le dossier [visualisations](https://github.com/IdrissaD/legislatives_2024/tree/main/visualisations)

## Licences :

Code : [GNU General Public License v3.0](https://github.com/IdrissaD/legislatives_2024/blob/main/LICENSE)

Données : [ODbL](https://opendatacommons.org/licenses/odbl/summary/)

Images : [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

(En gros vous réutilisez ce que vous voulez, pour usage commercial ou non, mais vous devez conserver les mêmes licenses pour les réutilisations. Cycle vertueux de la donnée ouverte, tout ça...
