---- Requêtes permettant d'obtenir un certain nombre de statistiques complémentaires

-- Total de voix par bloc politique
SELECT sum(voix) AS somme_voix, nuance_bloc FROM resultats_par_candidat_e rpc GROUP BY nuance_bloc ORDER BY somme_voix DESC;

-- Nombre de candidat-es par bloc politique
SELECT count(*) AS nb_candidat_es, nuance_bloc FROM resultats_par_candidat_e GROUP BY nuance_bloc ORDER BY nb_candidat_es DESC;

-- Nombre de candidat-es de chaque sexe/genre par bloc politique
SELECT count(*) AS nb_candidats, nuance_bloc FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'MASCULIN' GROUP BY nuance_bloc;
SELECT count(*) AS nb_candidates, nuance_bloc FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'FEMININ' GROUP BY nuance_bloc;

-- Proportion de femmes titulaires par bloc politique
WITH nb_femmes_titulaires AS (
    SELECT count(*) AS nb_candidates, nuance_bloc FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'FEMININ' GROUP BY nuance_bloc
),
nb_total AS (
    SELECT count(*) AS nb_candidat_es, nuance_bloc FROM resultats_par_candidat_e GROUP BY nuance_bloc
)
SELECT
    trunc((nb_femmes_titulaires.nb_candidates::numeric/nb_total.nb_candidat_es::numeric)*100, 2) AS proportion_candidates_sur_total,
    nb_femmes_titulaires.nuance_bloc
FROM nb_femmes_titulaires JOIN nb_total ON nb_femmes_titulaires.nuance_bloc = nb_total.nuance_bloc;

-- Proportion de femmes en première position du premier tour par bloc politique
WITH nb_feminin_premiere_position AS (
    SELECT count(*) AS nb_candidates, nuance_bloc FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'FEMININ' AND "position" = 1 GROUP BY nuance_bloc
),
nb_total AS (
    SELECT count(*) AS nb_candidat_es, nuance_bloc FROM resultats_par_candidat_e GROUP BY nuance_bloc
)
SELECT
    trunc((nb_feminin_premiere_position.nb_candidates::numeric/nb_total.nb_candidat_es::numeric)*100, 2) AS proportion_premiere_position_sur_total_candidates,
    nb_feminin_premiere_position.nuance_bloc
FROM nb_feminin_premiere_position JOIN nb_total ON nb_feminin_premiere_position.nuance_bloc = nb_total.nuance_bloc;
