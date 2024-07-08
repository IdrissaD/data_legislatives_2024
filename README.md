Projet de mise à disposition de données ordonnées, de chiffres-clefs et de visualisations inédites sur les élections législatives françaises anticipées de 2024.

## Visualisations :

Si vous consultez ce README depuis GitHub, cliquez [ici](https://idrissad.github.io/data_legislatives_2024/) pour avoir accès aux visualisations interactives.

Images issues des visualisations interactives téléchargeables [ici](https://github.com/IdrissaD/data_legislatives_2024/tree/main/visualisations).

<div class="flourish-embed flourish-chart" data-src="visualisation/18623753"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

<details>
  <summary><b>⬊ 20 autres nuances</b></summary>
<div class="flourish-embed flourish-chart" data-src="visualisation/18624186"><script src="https://public.flourish.studio/resources/embed.js"></script></div>
</details>

<div class="flourish-embed flourish-chart" data-src="visualisation/18623377"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

## Données source :

- [Résultats provisoires du 1er tour - Ministère de l'Intérieur et des Outre-Mer](https://www.data.gouv.fr/fr/datasets/elections-legislatives-des-30-juin-et-7-juillet-2024-resultats-provisoires-du-1er-tour/)
- [Coordonnées géographiques des circonscriptions - INSEE](https://www.insee.fr/fr/statistiques/6441661?sommaire=6436478)

Résultats des 577 circonscriptions françaises.

## Méthode :

- Jointure des résultats avec les données géolocalisées via le code de circonscription.
- Réordonnançement des données avec PostgreSQL (renommage et retypage des champs, création d'une ligne par candidat·e, etc.) (cf. [preparation_des_donnees.sql](https://github.com/IdrissaD/data_legislatives_2024/requetes_sql/))
- Attribution d'un bloc de clivage à chacune des 24 nuances [définies par le Ministère de l'Intérieur](https://www.resultats-elections.interieur.gouv.fr/legislatives2024/referentiel.html)

<details>
  <summary><b>⬊ Nuances et leur regroupement par bloc de clivage</b></summary>
  <table>
    <thead><tr><th>Code</th><th>Nuance (définie par le Ministère de l'Intérieur et des Outre-mer)</th><th>Commentaires du Ministère</th><th>Bloc de clivage (défini subjectivement par mes soins)</th></tr></thead><tbody><tr><td>EXG</td><td>Extrême gauche</td><td>Candidats présentés ou soutenus par des partis d'extrême gauche, notamment Lutte ouvrière, le nouveau Parti Anticapitaliste, Parti ouvrier indépendant</td><td>extrême gauche</td></tr><tr><td>COM</td><td>Parti communiste français</td><td>Candidats présentés ou soutenus par le Parti communiste Français</td><td>gauche</td></tr><tr><td>FI</td><td>La France insoumise</td><td>Candidats présentés ou soutenus par La France insoumise</td><td>gauche</td></tr><tr><td>SOC</td><td>Parti socialiste</td><td>Candidats présentés ou soutenus par le Parti socialiste</td><td>gauche</td></tr><tr><td>RDG</td><td>Parti radical de gauche</td><td>Candidats présentés ou soutenus par le Parti radical de gauche</td><td>gauche</td></tr><tr><td>VEC</td><td>Les Écologistes</td><td>Candidats présentés ou soutenus par Les Écologistes</td><td>gauche</td></tr>
    <tr><td>DVG</td><td>Divers gauche</td><td>Autres candidats de sensibilité de gauche</td><td>gauche</td></tr><tr><td>UG</td><td>Union de la gauche</td><td>Candidats présentés ou soutenus par deux partis de gauche</td><td>gauche</td></tr><tr><td>ECO</td><td>Ecologiste</td><td>Autres candidats de sensibilité écologiste</td><td>gauche</td></tr><tr><td>REG</td><td>Régionalistes</td><td>Candidats régionalistes, indépendantistes et autonomistes</td><td>divers</td></tr><tr><td>DIV</td><td>Divers</td><td>Candidats inclassables</td><td>divers</td></tr><tr><td>REN</td><td>Renaissance</td><td>Candidats présentés ou soutenus par Renaissance</td><td>centre</td></tr><tr><td>MOM</td><td>Modem</td><td>Candidats présentés ou soutenus par le Mouvement démocrate</td><td>centre</td></tr><tr><td>HOR</td><td>Horizons</td><td>Candidats présentés ou soutenus par Horizons</td><td>centre</td></tr>
    <tr><td>ENS</td><td>Ensemble</td><td>Candidats présentés ou soutenus par deux partis du centre</td><td>centre</td></tr><tr><td>DVC</td><td>Divers centre</td><td>Autres candidats de sensibilité du centre</td><td>centre</td></tr><tr><td>UDI</td><td>Union des Démocrates et Indépendants</td><td>Candidats présentés ou soutenus par l'Union des démocrates et indépendants</td><td>centre</td></tr><tr><td>LR</td><td>Les Républicains</td><td>Candidats présentés ou soutenus par Les Républicains</td><td>droite</td></tr><tr><td>DVD</td><td>Divers droite</td><td>Autres candidats de sensibilité de droite</td><td>droite</td></tr><tr><td>DSV</td><td>Droite souverainiste</td><td>Debout la France, autres partis ou candidats de sensibilité souverainiste</td><td>extrême droite</td></tr><tr><td>RN</td><td>Rassemblement National</td><td>Candidats présentés ou soutenus par le Rassemblement national</td><td>extrême droite</td></tr>
    <tr><td>REC</td><td>Reconquête</td><td>Candidats présentés ou soutenus par Reconquête !</td><td>extrême droite</td></tr><tr><td>UXO</td><td>Union de l'extrême droite</td><td>Candidats présentés ou soutenus par deux partis d'extrême droite</td><td>extrême droite</td></tr><tr><td>EXD</td><td>Extrême droite</td><td>Candidats présentés ou soutenus par d'autres partis d'extrême droite, notamment Les Patriotes, Comités Jeanne, Mouvement National Républicain, Les identitaires , Ligue du Sud, Parti de la France, Souveraineté, Identité et Libertés (SI EL), Front des patriotes républicains, etc.</td><td>extrême droite</td></tr></tbody>
  </table>
</details>


## Données produites :

- liste des 70 102 bureau de votes des législatives 2024, avec leur commune, circonscription législative, arrondissement, département et région respectifs
- tableau des nuances et blocs de clivages se présentant aux législatives 2024
- liste des 
- résultats du 1er tour des législatives 2024, circonscription par circonscription (fichiers géolocalisés)
- résultats du 1er tour des législatives 2024, candidat·e par candidat·e (un fichier géolocalisé, un fichier CSV)
- statistiques genrées :
  - Répartition des positions (qualifiable, élu·e) après le premier tour selon le département, la nuance et le bloc de clivage
  - Nombre de voix moyen et médian, taux de votes par rapport au nombre d'inscriptions et de votes exprimés, par département, nuance et bloc de clivage

Données téléchargeables sur [data.gouv.fr](https://www.data.gouv.fr/fr/datasets/resultats-provisoires-des-elections-legislatives-francaises-2024-donnees-geolocalisees/) et [GitHub](https://github.com/IdrissaD/data_legislatives_2024/donnees_produites)

Visualisations interactives disponibles sur Flourish : https://app.flourish.studio/@idrissad

## Licences :

Code : [GNU General Public License v3.0](https://github.com/IdrissaD/data_legislatives_2024/blob/main/LICENSE)

Données : [ODbL](https://opendatacommons.org/licenses/odbl/summary/)

Images : [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

(En gros vous réutilisez ce que vous voulez, pour usage commercial ou non, mais vous devez conserver les mêmes licences pour les réutilisations. Cycle vertueux de la donnée ouverte, tout ça...)
