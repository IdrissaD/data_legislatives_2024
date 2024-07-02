---- Création d'une table temporaire calculant la répartition genrée des candidat·es et de leurs positions en nombres absolus
-- Un·e candidat·e est considérée comme qualifiable si son nombre de voix est supérieur à 12,5 % du nombre d'inscriptions sur la liste électorale de sa circonscription.
-- Cela ne signifie pas que tou·tes les candidat·es qualifiables ont effectivement été qualifiées (par exemple si un·e autre candidat·e est élu·e dès le 1er tour)
-- Cela ne signifie pas non plus que tou·tes les candidat·es non qualifiables n'ont pas été qualifiées (par exemple si une seule liste a dépassé le seuil, la deuxième liste peut être qualifiée sans avoir elle-même atteint le seuil) 
-- Les statistiques sur le sexe/genre des candidat·es se fondent sur l'information contenue dans les données du Ministère de l'Intérieur, sans préjuger du genre réel des candidat·es.
DROP TABLE IF EXISTS repartition_genree_temp;

CREATE TABLE repartition_genree_temp
AS SELECT DISTINCT
    (SELECT count(*) FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'FEMININ') AS nb_candidates,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'MASCULIN') AS nb_candidats,
    (SELECT count(*) FROM resultats_par_candidat_e) AS nb_total_candidat_es,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'FEMININ' AND "position" = 1) AS nb_candidates_en_premiere_position,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'MASCULIN' AND "position" = 1) AS nb_candidats_en_premiere_position,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE "position" = 1) AS nb_total_circos,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'FEMININ' AND rapport_voix_inscrits >= 12.5) AS nb_candidates_qualifiables,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE sexe_candidat_e = 'MASCULIN' AND rapport_voix_inscrits >= 12.5) AS nb_candidats_qualifiables,
    (SELECT count(*) FROM resultats_par_candidat_e WHERE rapport_voix_inscrits >= 12.5) AS nb_total_candidat_es_qualifiables
FROM resultats_par_candidat_e rpc;


---- Création d'une table reprenant les nombres absolus de la table temporaire et calculant un ensemble de statistiques sous forme de taux
DROP TABLE IF EXISTS repartition_genree;

CREATE TABLE repartition_genree
AS SELECT
    nb_total_candidat_es,
    nb_candidates,
    trunc((nb_candidates::NUMERIC/nb_total_candidat_es::NUMERIC)*100, 2) AS rapport_nb_candidates_nb_total_candidat_es,
    nb_candidats,
    trunc((nb_candidats::NUMERIC/nb_total_candidat_es::NUMERIC)*100, 2) AS rapport_nb_candidats_nb_total_candidat_es,
    nb_total_circos,
    nb_candidates_en_premiere_position,
    trunc((nb_candidates_en_premiere_position::NUMERIC/nb_candidates::NUMERIC)*100, 2) AS rapport_nb_candidates_en_premiere_position_nb_candidates,
    trunc((nb_candidates_en_premiere_position::NUMERIC/nb_total_circos::NUMERIC)*100, 2) AS rapport_nb_candidates_en_premiere_position_nb_total_circos,
    nb_candidats_en_premiere_position,
    trunc((nb_candidats_en_premiere_position::NUMERIC/nb_candidats::NUMERIC)*100, 2) AS rapport_nb_candidats_en_premiere_position_nb_candidats,
    trunc((nb_candidats_en_premiere_position::NUMERIC/nb_total_circos::NUMERIC)*100, 2) AS rapport_nb_candidats_en_premiere_position_nb_total_circos,
    nb_total_candidat_es_qualifiables,
    nb_candidates_qualifiables,
    trunc((nb_candidates_qualifiables::NUMERIC/nb_candidates::NUMERIC)*100, 2) AS rapport_nb_candidates_qualifiables_nb_candidates,
    trunc((nb_candidates_qualifiables::NUMERIC/nb_total_candidat_es_qualifiables::NUMERIC)*100, 2) AS rapport_nb_candidates_qualifiables_nb_total_candidat_es_qualifiables,
    nb_candidats_qualifiables,
    trunc((nb_candidats_qualifiables::NUMERIC/nb_candidats::NUMERIC)*100, 2) AS rapport_nb_candidats_qualifiables_nb_candidats,
    trunc((nb_candidats_qualifiables::NUMERIC/nb_total_candidat_es_qualifiables::NUMERIC)*100, 2) AS rapport_nb_candidats_qualifiables_nb_total_candidat_es_qualifiables
FROM repartition_genree_temp;
