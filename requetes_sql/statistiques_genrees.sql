---- Création d'une table temporaire calculant la répartition genrée des candidat·es et de leurs positions en nombres absolus
-- Un·e candidat·e est considérée comme qualifiable si son nombre de voix est supérieur à 12,5 % du nombre d'inscriptions sur la liste électorale de sa circonscription.
-- Cela ne signifie pas que tou·tes les candidat·es qualifiables ont effectivement été qualifiées (par exemple si un·e autre candidat·e est élu·e dès le 1er tour)
-- Cela ne signifie pas non plus que tou·tes les candidat·es non qualifiables n'ont pas été qualifiées (par exemple si une seule liste a dépassé le seuil, la deuxième liste peut être qualifiée sans avoir elle-même atteint le seuil) 
-- Les statistiques sur le sexe/genre des candidat·es se fondent sur l'information contenue dans les données du Ministère de l'Intérieur, sans préjuger du genre réel des candidat·es.


---- REPARTITION DES POSITIONS (qualifiable, élu-e...)

-- Répartition genrée par département, nuance et bloc politique
DROP TABLE IF EXISTS repartition_genree_positions_par_departement_nuance_et_bloc;

CREATE TABLE repartition_genree_positions_par_departement_nuance_et_bloc
AS
SELECT
    dep_code,
    nuance,
    nuance_bloc,
    "genre_candidat-e" AS "genre_candidat-es",
    count(*) AS "candidat-es",
    count("taux_voix/inscriptions" >= 12.5 OR NULL) AS qualifiables,
    count("position" = 1 OR NULL) AS premiere_position,
    count("elu-e" = TRUE OR NULL) AS "elu-es"
FROM resultats_par_candidat_e
GROUP BY dep_code, nuance, nuance_bloc, "genre_candidat-e"
ORDER BY dep_code, nuance_bloc, nuance, "genre_candidat-e";


-- Répartition genrée par nuance et bloc politique
DROP TABLE IF EXISTS repartition_genree_positions_par_nuance_et_bloc;

CREATE TABLE repartition_genree_positions_par_nuance_et_bloc
AS
SELECT
    nuance,
    nuance_bloc,
    "genre_candidat-es",
    sum("candidat-es") AS "candidat-es",
    sum(qualifiables) AS qualifiables,
    sum(premiere_position) AS premiere_position,
    sum("elu-es") AS "elu-es"
FROM repartition_genree_positions_par_departement_nuance_et_bloc
GROUP BY nuance, nuance_bloc, "genre_candidat-es"
ORDER BY nuance_bloc, nuance, "genre_candidat-es";


-- Répartition genrée par bloc politique
DROP TABLE IF EXISTS repartition_genree_positions_par_bloc;

CREATE TABLE repartition_genree_positions_par_bloc
AS
SELECT
    nuance_bloc,
    "genre_candidat-es",
    sum("candidat-es") AS "candidat-es",
    sum(qualifiables) AS qualifiables,
    sum(premiere_position) AS premiere_position,
    sum("elu-es") AS "elu-es"
FROM repartition_genree_positions_par_nuance_et_bloc
GROUP BY nuance_bloc, "genre_candidat-es"
ORDER BY nuance_bloc, "genre_candidat-es";


-- Répartition genrée générale
DROP TABLE IF EXISTS repartition_genree_positions_generales;

CREATE TABLE repartition_genree_positions_generales
AS
SELECT
    "genre_candidat-es",
    sum("candidat-es") AS "candidat-es",
    sum(qualifiables) AS qualifiables,
    sum(premiere_position) AS premiere_position,
    sum("elu-es") AS "elu-es"
FROM repartition_genree_positions_par_bloc
GROUP BY "genre_candidat-es"
ORDER BY "genre_candidat-es";


-- Répartition genrée par département
DROP TABLE IF EXISTS repartition_genree_positions_par_departement;

CREATE TABLE repartition_genree_positions_par_departement
AS
SELECT
    dep_code,
    "genre_candidat-es",
    sum("candidat-es") AS "candidat-es",
    sum(qualifiables) AS qualifiables,
    sum(premiere_position) AS premiere_position,
    sum("elu-es") AS "elu-es"
FROM repartition_genree_positions_par_departement_nuance_et_bloc
GROUP BY dep_code, "genre_candidat-es"
ORDER BY dep_code, "genre_candidat-es";


---- MOYENNES ET MEDIANES DE VOIX ET POURCENTAGES


-- Résultats en nombre de voix et pourcentages moyens et médians par genre, département, nuance et bloc politique
DROP TABLE IF EXISTS repartition_genree_voix_et_pourcentages_par_departement_nuance_et_bloc;

CREATE TABLE repartition_genree_voix_et_pourcentages_par_departement_nuance_et_bloc
AS
SELECT
    dep_code,
    nuance,
    nuance_bloc,
    "genre_candidat-e" AS "genre_candidat-es",
    round(avg(voix)) AS voix_moyenne,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY voix) AS voix_mediane,
    round(avg("taux_voix/inscriptions"),2) AS "taux_voix/inscriptions_moyenne",
    round(avg("taux_voix/exprimes"),2) AS "taux_voix/exprimes_moyenne"
FROM resultats_par_candidat_e
GROUP BY dep_code, nuance, nuance_bloc, "genre_candidat-e"
ORDER BY dep_code, nuance_bloc, nuance, "genre_candidat-e";

-- Résultats en nombre de voix et pourcentages moyens et médians par genre, nuance et bloc politique
DROP TABLE IF EXISTS repartition_genree_voix_et_pourcentages_par_nuance_et_bloc;

CREATE TABLE repartition_genree_voix_et_pourcentages_par_nuance_et_bloc
AS
SELECT
    nuance,
    nuance_bloc,
    "genre_candidat-e" AS "genre_candidat-es",
    round(avg(voix)) AS voix_moyenne,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY voix) AS voix_mediane,
    round(avg("taux_voix/inscriptions"),2) AS "taux_voix/inscriptions_moyenne",
    round(avg("taux_voix/exprimes"),2) AS "taux_voix/exprimes_moyenne"
FROM resultats_par_candidat_e
GROUP BY nuance, nuance_bloc, "genre_candidat-e"
ORDER BY nuance_bloc, nuance, "genre_candidat-e"


;-- Résultats en nombre de voix et pourcentages moyens et médians par genre et bloc politique
DROP TABLE IF EXISTS repartition_genree_voix_et_pourcentages_par_bloc;

CREATE TABLE repartition_genree_voix_et_pourcentages_par_bloc
AS
SELECT
    nuance_bloc,
    "genre_candidat-e" AS "genre_candidat-es",
    round(avg(voix)) AS voix_moyenne,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY voix) AS voix_mediane,
    round(avg("taux_voix/inscriptions"),2) AS "taux_voix/inscriptions_moyenne",
    round(avg("taux_voix/exprimes"),2) AS "taux_voix/exprimes_moyenne"
FROM resultats_par_candidat_e
GROUP BY nuance_bloc, "genre_candidat-e"
ORDER BY nuance_bloc, "genre_candidat-e"


;-- Résultats en nombre de voix et pourcentages moyens et médians par genre
DROP TABLE IF EXISTS repartition_genree_voix_et_pourcentages;

CREATE TABLE repartition_genree_voix_et_pourcentages
AS
SELECT
    "genre_candidat-e" AS "genre_candidat-es",
    round(avg(voix)) AS voix_moyenne,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY voix) AS voix_mediane,
    round(avg("taux_voix/inscriptions"),2) AS "taux_voix/inscriptions_moyenne",
    round(avg("taux_voix/exprimes"),2) AS "taux_voix/exprimes_moyenne"
FROM resultats_par_candidat_e
GROUP BY "genre_candidat-e"
ORDER BY "genre_candidat-e";


-- Résultats en nombre de voix et pourcentages moyens et médians par genre et département
DROP TABLE IF EXISTS repartition_genree_voix_et_pourcentages_par_departement;

CREATE TABLE repartition_genree_voix_et_pourcentages_par_departement
AS
SELECT
    dep_code,
    "genre_candidat-e" AS "genre_candidat-es",
    round(avg(voix)) AS voix_moyenne,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY voix) AS voix_mediane,
    round(avg("taux_voix/inscriptions"),2) AS "taux_voix/inscriptions_moyenne",
    round(avg("taux_voix/exprimes"),2) AS "taux_voix/exprimes_moyenne"
FROM resultats_par_candidat_e
GROUP BY dep_code, "genre_candidat-e"
ORDER BY dep_code, "genre_candidat-e";