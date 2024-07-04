---- Requêtes permettant d'obtenir des statistiques complémentaires

-- Total de voix par bloc politique
SELECT sum(voix) AS somme_voix, nuance_bloc FROM resultats_par_candidat_e rpc GROUP BY nuance_bloc ORDER BY somme_voix DESC;

-- Nombre de candidat-es par bloc politique
SELECT count(*) AS nb_candidat_es, nuance_bloc FROM resultats_par_candidat_e GROUP BY nuance_bloc ORDER BY nb_candidat_es DESC;
