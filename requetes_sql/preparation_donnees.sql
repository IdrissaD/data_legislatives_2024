---- Création d'une table de tous les bureaux de vote avec leurs échelons administratifs respectifs
DROP TABLE IF EXISTS bureau;

CREATE TABLE bureau AS
SELECT
 trim(bv."Code BV") AS bureau_code,
 trim(bv."Code commune") AS com_code,
 trim(bv."Libellé commune") AS com_lib,
 trim(circo."Code circonscription législative") AS circo_code,
 trim(circo."Libellé circonscription législative") AS circo_lib,
 trim(bv."Code département") AS dep_code,
 trim(bv."Libellé département") AS dep_lib,
 NULL::varchar AS reg_code,
 NULL::varchar AS reg_lib
FROM
donnees_source.resultats_provisoires_par_bureau_de_votevmn bv -- source : Ministère via data.gouv.fr 
JOIN donnees_source.resultats_provisoires_par_circonscription circo -- source : Ministère via data.gouv.fr 
ON bv."Nuance candidat 1" = circo."Nuance candidat 1"
AND bv."Nom candidat 1" = circo."Nom candidat 1"
AND bv."Prénom candidat 1" = circo."Prénom candidat 1";

UPDATE bureau bv
SET reg_code = "REG"
FROM donnees_source.v_commune_2024 vc -- source : INSEE
WHERE vc."DEP" = bv."dep_code"
AND vc.typecom = 'COM';

UPDATE bureau bv
SET reg_lib = "LIBELLE"
FROM donnees_source.v_region_2024 vc -- source : INSEE
WHERE vc."REG" = bv."reg_code";


---- Création de tables avec les nombres de votes pour chaque échelon électoral
-- Votes par bureau
DROP TABLE IF EXISTS bureau_votes;

CREATE TABLE bureau_votes AS
SELECT
    bureau.*,
    rb."Inscrits"::numeric AS inscriptions,
    rb."Votants"::numeric AS votes,
    round(rb."Votants"::numeric/rb."Inscrits"::numeric, 3) AS votes_taux,
    rb."Abstentions"::numeric AS abstentions,
    round(rb."Abstentions"::numeric/rb."Inscrits"::numeric, 3) AS abstentions_taux,
    rb."Exprimés"::numeric AS exprimes,
    round(rb."Exprimés"::numeric/rb."Inscrits"::numeric, 3) AS exprimes_sur_inscriptions,
    round(rb."Exprimés"::numeric/rb."Votants"::numeric, 3) AS exprimes_sur_votes,
    rb."Blancs"::numeric AS blancs,
    round(rb."Blancs"::numeric/rb."Inscrits"::numeric, 3) AS blancs_sur_inscriptions,
    round(rb."Blancs"::numeric/rb."Votants"::numeric, 3) AS blancs_sur_votes,
    rb."Nuls"::numeric AS nuls,
    round(rb."Nuls"::numeric/rb."Inscrits"::numeric, 3) AS nuls_sur_inscriptions,
    round(rb."Nuls"::numeric/rb."Votants"::numeric, 3) AS nuls_sur_votes
FROM bureau
JOIN donnees_source.resultats_provisoires_par_bureau_de_votevmn rb
ON bureau.bureau_code = rb."Code BV"
AND bureau.com_code = rb."Code commune"
AND rb."Votants" != 0;

-- Votes par commune
DROP TABLE IF EXISTS commune_votes;

CREATE TABLE commune_votes AS
SELECT
    com_code,
    com_lib,
    circo_code,
    circo_lib,
    dep_code,
    dep_lib,
    reg_code,
    reg_lib,
    sum(inscriptions) AS inscriptions,
    sum(votes) AS votes,
    round(sum(votes)/sum(inscriptions), 3) AS votes_taux,
    sum(abstentions) AS abstentions,
    round(sum(abstentions)/sum(inscriptions), 3) AS abstentions_taux,
    sum(exprimes) AS exprimes,
    round(sum(exprimes)/sum(inscriptions), 3) AS exprimes_sur_inscriptions,
    round(sum(exprimes)/sum(votes), 3) AS exprimes_sur_votes,
    sum(blancs) AS blancs,
    round(sum(blancs)/sum(inscriptions), 3) AS blancs_sur_inscriptions,
    round(sum(blancs)/sum(votes), 3) AS blancs_sur_votes,
    sum(nuls) AS nuls,
    round(sum(nuls)/sum(inscriptions), 3) AS nuls_sur_inscriptions,
    round(sum(nuls)/sum(votes), 3) AS nuls_sur_votes
FROM bureau_votes
GROUP BY
    com_code,
    com_lib,
    circo_code,
    circo_lib,
    dep_code,
    dep_lib,
    reg_code,
    reg_lib;
    
-- Votes par circonscription
DROP TABLE IF EXISTS circonscription_votes;

CREATE TABLE circonscription_votes AS
SELECT
    circo_code,
    circo_lib,
    dep_code,
    dep_lib,
    reg_code,
    reg_lib,
    sum(inscriptions) AS inscriptions,
    sum(votes) AS votes,
    round(sum(votes)/sum(inscriptions), 3) AS votes_taux,
    sum(abstentions) AS abstentions,
    round(sum(abstentions)/sum(inscriptions), 3) AS abstentions_taux,
    sum(exprimes) AS exprimes,
    round(sum(exprimes)/sum(inscriptions), 3) AS exprimes_sur_inscriptions,
    round(sum(exprimes)/sum(votes), 3) AS exprimes_sur_votes,
    sum(blancs) AS blancs,
    round(sum(blancs)/sum(inscriptions), 3) AS blancs_sur_inscriptions,
    round(sum(blancs)/sum(votes), 3) AS blancs_sur_votes,
    sum(nuls) AS nuls,
    round(sum(nuls)/sum(inscriptions), 3) AS nuls_sur_inscriptions,
    round(sum(nuls)/sum(votes), 3) AS nuls_sur_votes
FROM bureau_votes
GROUP BY
    circo_code,
    circo_lib,
    dep_code,
    dep_lib,
    reg_code,
    reg_lib;

-- Votes par département
DROP TABLE IF EXISTS departement_votes;

CREATE TABLE departement_votes AS
SELECT
    dep_code,
    dep_lib,
    reg_code,
    reg_lib,
    sum(inscriptions) AS inscriptions,
    sum(votes) AS votes,
    round(sum(votes)/sum(inscriptions), 3) AS votes_taux,
    sum(abstentions) AS abstentions,
    round(sum(abstentions)/sum(inscriptions), 3) AS abstentions_taux,
    sum(exprimes) AS exprimes,
    round(sum(exprimes)/sum(inscriptions), 3) AS exprimes_sur_inscriptions,
    round(sum(exprimes)/sum(votes), 3) AS exprimes_sur_votes,
    sum(blancs) AS blancs,
    round(sum(blancs)/sum(inscriptions), 3) AS blancs_sur_inscriptions,
    round(sum(blancs)/sum(votes), 3) AS blancs_sur_votes,
    sum(nuls) AS nuls,
    round(sum(nuls)/sum(inscriptions), 3) AS nuls_sur_inscriptions,
    round(sum(nuls)/sum(votes), 3) AS nuls_sur_votes
FROM bureau_votes
GROUP BY
    dep_code,
    dep_lib,
    reg_code,
    reg_lib;

-- Votes par région
DROP TABLE IF EXISTS region_votes;

CREATE TABLE region_votes AS
SELECT
    reg_code,
    reg_lib,
    sum(inscriptions) AS inscriptions,
    sum(votes) AS votes,
    round(sum(votes)/sum(inscriptions), 3) AS votes_taux,
    sum(abstentions) AS abstentions,
    round(sum(abstentions)/sum(inscriptions), 3) AS abstentions_taux,
    sum(exprimes) AS exprimes,
    round(sum(exprimes)/sum(inscriptions), 3) AS exprimes_sur_inscriptions,
    round(sum(exprimes)/sum(votes), 3) AS exprimes_sur_votes,
    sum(blancs) AS blancs,
    round(sum(blancs)/sum(inscriptions), 3) AS blancs_sur_inscriptions,
    round(sum(blancs)/sum(votes), 3) AS blancs_sur_votes,
    sum(nuls) AS nuls,
    round(sum(nuls)/sum(inscriptions), 3) AS nuls_sur_inscriptions,
    round(sum(nuls)/sum(votes), 3) AS nuls_sur_votes
FROM bureau_votes
GROUP BY
    reg_code,
    reg_lib;


---- Création de table des résultats des candidat·es pour chaque échelon électoral

-- Résultats par bureau
DROP TABLE IF EXISTS "candidat-e_resultats_bureaux";

CREATE TABLE "candidat-e_resultats_bureaux" AS
    SELECT
        "Nom candidat 1" AS "nom",
        "Prénom candidat 1" AS "prenom",
        lower("Sexe candidat 1") AS "genre",
        "Numéro de panneau 1" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 1" AS nuance,
        "Voix 1"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 1" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 1", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 1" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 1" != ''
    UNION
    SELECT
        "Nom candidat 2" AS "nom",
        "Prénom candidat 2" AS "prenom",
        lower("Sexe candidat 2") AS "genre",
        "Numéro de panneau 2" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 2" AS nuance,
        "Voix 2"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 2" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 2", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 2" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 2" != ''
    UNION
    SELECT
        "Nom candidat 3" AS "nom",
        "Prénom candidat 3" AS "prenom",
        lower("Sexe candidat 3") AS "genre",
        "Numéro de panneau 3" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 3" AS nuance,
        "Voix 3"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 3" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 3", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 3" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 3" != ''
    UNION
    SELECT
        "Nom candidat 4" AS "nom",
        "Prénom candidat 4" AS "prenom",
        lower("Sexe candidat 4") AS "genre",
        "Numéro de panneau 4" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 4" AS nuance,
        "Voix 4"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 4" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 4", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 4" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 4" != ''
    UNION
    SELECT
        "Nom candidat 5" AS "nom",
        "Prénom candidat 5" AS "prenom",
        lower("Sexe candidat 5") AS "genre",
        "Numéro de panneau 5" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 5" AS nuance,
        "Voix 5"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 5" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 5", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 5" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 5" != ''
    UNION
    SELECT
        "Nom candidat 6" AS "nom",
        "Prénom candidat 6" AS "prenom",
        lower("Sexe candidat 6") AS "genre",
        "Numéro de panneau 6" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 6" AS nuance,
        "Voix 6"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 6" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 6", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 6" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 6" != ''
    UNION
    SELECT
        "Nom candidat 7" AS "nom",
        "Prénom candidat 7" AS "prenom",
        lower("Sexe candidat 7") AS "genre",
        "Numéro de panneau 7" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 7" AS nuance,
        "Voix 7"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 7" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 7", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 7" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 7" != ''
    UNION
    SELECT
        "Nom candidat 8" AS "nom",
        "Prénom candidat 8" AS "prenom",
        lower("Sexe candidat 8") AS "genre",
        "Numéro de panneau 8" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 8" AS nuance,
        "Voix 8"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 8" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 8", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 8" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 8" != ''
    UNION
    SELECT
        "Nom candidat 9" AS "nom",
        "Prénom candidat 9" AS "prenom",
        lower("Sexe candidat 9") AS "genre",
        "Numéro de panneau 9" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 9" AS nuance,
        "Voix 9"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 9" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 9", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 9" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 9" != ''
    UNION
    SELECT
        "Nom candidat 10" AS "nom",
        "Prénom candidat 10" AS "prenom",
        lower("Sexe candidat 10") AS "genre",
        "Numéro de panneau 10" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 10" AS nuance,
        "Voix 10"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 10" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 10", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 10" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 10" != ''
    UNION
    SELECT
        "Nom candidat 11" AS "nom",
        "Prénom candidat 11" AS "prenom",
        lower("Sexe candidat 11") AS "genre",
        "Numéro de panneau 11" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 11" AS nuance,
        "Voix 11"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 11" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 11", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 11" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 11" != ''
    UNION
    SELECT
        "Nom candidat 12" AS "nom",
        "Prénom candidat 12" AS "prenom",
        lower("Sexe candidat 12") AS "genre",
        "Numéro de panneau 12" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 12" AS nuance,
        "Voix 12"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 12" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 12", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 12" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 12" != ''
    UNION
    SELECT
        "Nom candidat 13" AS "nom",
        "Prénom candidat 13" AS "prenom",
        lower("Sexe candidat 13") AS "genre",
        "Numéro de panneau 13" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 13" AS nuance,
        "Voix 13"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 13" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 13", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 13" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 13" != ''
    UNION
    SELECT
        "Nom candidat 14" AS "nom",
        "Prénom candidat 14" AS "prenom",
        lower("Sexe candidat 14") AS "genre",
        "Numéro de panneau 14" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 14" AS nuance,
        "Voix 14"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 14" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 14", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 14" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 14" != ''
    UNION
    SELECT
        "Nom candidat 15" AS "nom",
        "Prénom candidat 15" AS "prenom",
        lower("Sexe candidat 15") AS "genre",
        "Numéro de panneau 15" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 15" AS nuance,
        "Voix 15"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 15" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 15", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 15" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 15" != ''
    UNION
    SELECT
        "Nom candidat 16" AS "nom",
        "Prénom candidat 16" AS "prenom",
        lower("Sexe candidat 16") AS "genre",
        "Numéro de panneau 16" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 16" AS nuance,
        "Voix 16"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 16" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 16", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 16" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 16" != ''
    UNION
    SELECT
        "Nom candidat 17" AS "nom",
        "Prénom candidat 17" AS "prenom",
        lower("Sexe candidat 17") AS "genre",
        "Numéro de panneau 17" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 17" AS nuance,
        "Voix 17"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 17" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 17", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 17" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 17" != ''
    UNION
    SELECT
        "Nom candidat 18" AS "nom",
        "Prénom candidat 18" AS "prenom",
        lower("Sexe candidat 18") AS "genre",
        "Numéro de panneau 18" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 18" AS nuance,
        "Voix 18"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 18" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 18", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 18" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 18" != ''
    UNION
    SELECT
        "Nom candidat 19" AS "nom",
        "Prénom candidat 19" AS "prenom",
        lower("Sexe candidat 19") AS "genre",
        "Numéro de panneau 19" AS numero_panneau,
        "Code BV" AS bureau_code,
        "Code commune" AS com_code,
        "Nuance candidat 19" AS nuance,
        "Voix 19"::numeric AS voix,
        NULL::numeric AS voix_sur_inscriptions,
        NULL::numeric AS voix_sur_exprimes,
        NULL::integer AS "position",
        CASE
            WHEN "% Voix/inscrits 19" = '' THEN FALSE
            WHEN REPLACE(REPLACE("% Voix/inscrits 19", '%', ''), ',', '.')::NUMERIC < 12.5 THEN FALSE
            ELSE TRUE
        END AS qualifiable_circo,
        CASE
            WHEN "Elu 19" = 'élu' THEN TRUE
            ELSE FALSE
        END AS "elu-e_circo"
    FROM donnees_source.resultats_provisoires_par_bureau_de_votevmn
    WHERE "Numéro de panneau 19" != '';


-- Calcul des pourcentages de voix pour chaque candidat·e
UPDATE "candidat-e_resultats_bureaux" crb
SET voix_sur_inscriptions = round(crb.voix/bv.inscriptions, 3),
    voix_sur_exprimes = round(crb.voix/bv.exprimes, 3)
FROM bureau_votes bv
WHERE bv.bureau_code = crb.bureau_code
AND bv.com_code = crb.com_code
AND bv.exprimes != 0;

-- Ajout des blocs de clivage
ALTER TABLE "candidat-e_resultats_bureaux"
ADD COLUMN bloc_clivage varchar;

UPDATE "candidat-e_resultats_bureaux" crb
SET bloc_clivage = nbc.bloc_clivage
FROM donnees_source.nuances_et_blocs_clivage nbc
WHERE crb.nuance = nbc.code;

-- Calcul de la position de chaque candidat·e pour l'échelon électoral concerné
CREATE TABLE "tmp_candidat-e_resultats_bureaux" AS
SELECT
  nom,
  prenom,
  genre,
  numero_panneau
  bureau_code,
  com_code,
  nuance,
  voix,
  voix_sur_inscriptions,
  voix_sur_exprimes,
  ROW_NUMBER () OVER (
  PARTITION BY bureau_code
    ORDER BY
      voix DESC
  ) AS "position",
  qualifiable_circo,
  "elu-e_circo",
  bloc_clivage
FROM
"candidat-e_resultats_bureaux";

DROP TABLE "candidat-e_resultats_bureaux";
ALTER TABLE "tmp_candidat-e_resultats_bureaux"
RENAME TO "candidat-e_resultats_bureaux";


-- Résultats par commune
DROP TABLE IF EXISTS "candidat-e_resultats_communes";


----------------------------------------------- OLD

---- Création d'une table joignant les tables "circo" et "resultats_par_candidat_e" avec une ligne par circonscription et les résultats des candidat-es en JSONb
DROP TABLE IF EXISTS resultats_par_circo;

CREATE TABLE resultats_par_circo
AS SELECT
    circo.circo_id,
    circo.circo_libelle,
    circo.dep_code,
    circo.dep_nom,
    circo.inscriptions,
    circo.votes,
    circo.vote_taux,
    circo.abstentions,
    circo.abstention_taux,
    circo.votes_exprimes,
    circo."taux_votes_exprimes/inscriptions",
    circo."taux_votes_exprimes/votes",
    circo.votes_blancs,
    circo."taux_votes_blancs/inscriptions",
    circo."taux_votes_blancs/votes",
    circo.votes_nuls,
    circo."taux_votes_nuls/inscriptions",
    circo."taux_votes_nuls/votes",
    circo.geom,
    json_agg(json_build_object(
            'nom_candidat-e', "nom_candidat-e",
            'prenom_candidat-e', "prenom_candidat-e",
            'genre_candidat-e', "genre_candidat-e",
            'numero_panneau', numero_panneau,
            'nuance', nuance,
            'nuance_bloc', nuance_bloc,
            'position', "position",
            'voix', voix,
            'taux_voix/inscriptions', "taux_voix/inscriptions",
            'taux_voix/exprimes', "taux_voix/exprimes",
            'elu-e', "elu-e"
        )) AS "resultats_candidat-es"
FROM circo JOIN resultats_par_candidat_e rpce ON circo.circo_id = rpce.circo_id AND circo.dep_code = rpce.dep_code
GROUP BY circo.circo_id,
    circo.circo_libelle,
    circo.dep_code,
    circo.dep_nom,
    circo.inscriptions,
    circo.votes,
    circo.vote_taux,
    circo.abstentions,
    circo.abstention_taux,
    circo.votes_exprimes,
    circo."taux_votes_exprimes/inscriptions",
    circo."taux_votes_exprimes/votes",
    circo.votes_blancs,
    circo."taux_votes_blancs/inscriptions",
    circo."taux_votes_blancs/votes",
    circo.votes_nuls,
    circo."taux_votes_nuls/inscriptions",
    circo."taux_votes_nuls/votes",
    circo.geom;

ALTER TABLE resultats_par_circo
ADD COLUMN "resultats_candidat-es_string" varchar;

UPDATE resultats_par_circo
SET "resultats_candidat-es_string" = "resultats_candidat-es"::varchar;
