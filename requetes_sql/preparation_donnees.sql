---- Création de la table des nuances et blocs politiques
CREATE TABLE public.nuance (
    nuance varchar NOT NULL,
    regroupement varchar NULL,
    CONSTRAINT nuance_pk PRIMARY KEY (nuance)
);

-- Renseignement de la table nuance (les blocs sont définis subjectivement par mes soins)
INSERT INTO nuance (nuance, bloc)
 VALUES
 ('EXG', 'extrême-gauche'), 
 ('UG', 'gauche'), ('FI', 'gauche'), ('ECO', 'gauche'), ('SOC', 'gauche'), ('DVG', 'gauche'), ('COM', 'gauche'), ('VEC', 'gauche'), ('RDG', 'gauche'),
 ('REN', 'centre'), ('ENS', 'centre'), ('MDM', 'centre'), ('HOR', 'centre'), ('DVC', 'centre'), ('UDI', 'centre'),
 ('LR', 'droite'), ('DVD', 'droite'),
 ('DSV', 'extrême-droite'), ('RN', 'extrême-droite'), ('REC', 'extrême-droite'), ('UXD', 'extrême-droite'), ('EXD', 'extrême-droite'),
 ('DIV', 'divers'), ('REG', 'divers');



---- Création d'une table des circonscritpions avec des champs renommés et uniquement les chiffres généraux de chaque circonscription
-- la table 'resultats_complets' est obtenue préalablement par une jointure entre
-- la couche géographique INSEE des circonscriptions et le fichier tabulaire des résultats provisoires du 1er tour du Ministère de l'Intérieur et de l'Outre-mer
DROP TABLE IF EXISTS circo;
 
CREATE TABLE circo AS
SELECT  id_circo AS circo_id,
        dep AS dep_code,
        "Libellé département" AS dep_nom,
        "Libellé circonscription législative" AS circo_libelle,
        "Inscrits" AS inscriptions,
        "Votants" AS votes,
        "% Votants" AS vote_taux,
        "Abstentions" AS abstentions,
        "% Abstentions" AS abstention_taux,
        "Exprimés" AS votes_exprimes,
        "% Exprimés/inscrits" AS taux_votes_exprimes_inscriptions,
        "% Exprimés/votants" AS taux_votes_exprimes_votes,
        "Blancs" AS votes_blancs,
        "% Blancs/inscrits" AS taux_votes_blancs_inscriptions,
        "% Blancs/votants" AS taux_votes_blancs_votes,
        "Nuls" AS votes_nuls,
        "% Nuls/inscrits" AS taux_votes_nuls_inscriptions,
        "% Nuls/votants" AS taux_votes_nuls_votes,
        geom
FROM resultats_complets rc;

-- Suppression des caractères '%' et remplacement des virgules par des points
UPDATE circo
SET vote_taux = REPLACE(REPLACE(vote_taux, '%', ''), ',', '.'),
    abstention_taux = REPLACE(REPLACE(abstention_taux, '%', ''), ',', '.'),
    taux_votes_exprimes_inscriptions = REPLACE(REPLACE(taux_votes_exprimes_inscriptions, '%', ''), ',', '.'),
    taux_votes_exprimes_votes = REPLACE(REPLACE(taux_votes_exprimes_votes, '%', ''), ',', '.'),
    taux_votes_blancs_inscriptions = REPLACE(REPLACE(taux_votes_blancs_inscriptions, '%', ''), ',', '.'),
    taux_votes_blancs_votes = REPLACE(REPLACE(taux_votes_blancs_votes, '%', ''), ',', '.'),
    taux_votes_nuls_inscriptions = REPLACE(REPLACE(taux_votes_nuls_inscriptions, '%', ''), ',', '.'),
    taux_votes_nuls_votes = REPLACE(REPLACE(taux_votes_nuls_votes, '%', ''), ',', '.');

-- Retypage des champs qui représentent des taux d'un type textuel à un type numérique
ALTER TABLE circo
ALTER COLUMN vote_taux TYPE NUMERIC USING vote_taux::numeric;

ALTER TABLE circo
ALTER COLUMN abstention_taux TYPE NUMERIC USING abstention_taux::numeric;

ALTER TABLE circo
ALTER COLUMN taux_votes_exprimes_inscriptions TYPE NUMERIC USING taux_votes_exprimes_inscriptions::numeric;

ALTER TABLE circo
ALTER COLUMN taux_votes_exprimes_votes TYPE NUMERIC USING taux_votes_exprimes_votes::numeric;

ALTER TABLE circo
ALTER COLUMN taux_votes_blancs_inscriptions TYPE NUMERIC USING taux_votes_blancs_inscriptions::numeric;

ALTER TABLE circo
ALTER COLUMN taux_votes_blancs_votes TYPE NUMERIC USING taux_votes_blancs_votes::numeric;

ALTER TABLE circo
ALTER COLUMN taux_votes_nuls_inscriptions TYPE NUMERIC USING taux_votes_nuls_inscriptions::numeric;

ALTER TABLE circo
ALTER COLUMN taux_votes_nuls_votes TYPE NUMERIC USING taux_votes_nuls_votes::numeric;
    
---- Création d'une table où chaque candidat·e a sa propre ligne
DROP TABLE IF EXISTS resultats_par_candidat_e;

CREATE TABLE resultats_par_candidat_e AS
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 1" AS numero_panneau,
"Nuance candidat 1" AS nuance_candidat_e,
"Nom candidat 1" AS nom_candidat_e,
"Prénom candidat 1" AS prenom_candidat_e,
"Sexe candidat 1" AS sexe_candidat_e,
"Voix 1" AS voix,
"% Voix/inscrits 1" AS rapport_voix_inscrits,
"% Voix/exprimés 1" AS rapport_voix_exprimes,
"Elu 1" AS elu_e
FROM resultats_complets rc
WHERE "Numéro de panneau 1" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 2",
"Nuance candidat 2",
"Nom candidat 2",
"Prénom candidat 2",
"Sexe candidat 2",
"Voix 2",
"% Voix/inscrits 2",
"% Voix/exprimés 2",
"Elu 2"
FROM resultats_complets rc
WHERE "Numéro de panneau 2" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 3",
"Nuance candidat 3",
"Nom candidat 3",
"Prénom candidat 3",
"Sexe candidat 3",
"Voix 3",
"% Voix/inscrits 3",
"% Voix/exprimés 3",
"Elu 3"
FROM resultats_complets rc
WHERE "Numéro de panneau 3" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 4",
"Nuance candidat 4",
"Nom candidat 4",
"Prénom candidat 4",
"Sexe candidat 4",
"Voix 4",
"% Voix/inscrits 4",
"% Voix/exprimés 4",
"Elu 4"
FROM resultats_complets rc
WHERE "Numéro de panneau 4" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 5",
"Nuance candidat 5",
"Nom candidat 5",
"Prénom candidat 5",
"Sexe candidat 5",
"Voix 5",
"% Voix/inscrits 5",
"% Voix/exprimés 5",
"Elu 5"
FROM resultats_complets rc
WHERE "Numéro de panneau 5" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 6",
"Nuance candidat 6",
"Nom candidat 6",
"Prénom candidat 6",
"Sexe candidat 6",
"Voix 6",
"% Voix/inscrits 6",
"% Voix/exprimés 6",
"Elu 6"
FROM resultats_complets rc
WHERE "Numéro de panneau 6" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 7",
"Nuance candidat 7",
"Nom candidat 7",
"Prénom candidat 7",
"Sexe candidat 7",
"Voix 7",
"% Voix/inscrits 7",
"% Voix/exprimés 7",
"Elu 7"
FROM resultats_complets rc
WHERE "Numéro de panneau 7" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 8",
"Nuance candidat 8",
"Nom candidat 8",
"Prénom candidat 8",
"Sexe candidat 8",
"Voix 8",
"% Voix/inscrits 8",
"% Voix/exprimés 8",
"Elu 8"
FROM resultats_complets rc
WHERE "Numéro de panneau 8" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 9",
"Nuance candidat 9",
"Nom candidat 9",
"Prénom candidat 9",
"Sexe candidat 9",
"Voix 9",
"% Voix/inscrits 9",
"% Voix/exprimés 9",
"Elu 9"
FROM resultats_complets rc
WHERE "Numéro de panneau 9" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 10",
"Nuance candidat 10",
"Nom candidat 10",
"Prénom candidat 10",
"Sexe candidat 10",
"Voix 10",
"% Voix/inscrits 10",
"% Voix/exprimés 10",
"Elu 10"
FROM resultats_complets rc
WHERE "Numéro de panneau 10" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 11",
"Nuance candidat 11",
"Nom candidat 11",
"Prénom candidat 11",
"Sexe candidat 11",
"Voix 11",
"% Voix/inscrits 11",
"% Voix/exprimés 11",
"Elu 11"
FROM resultats_complets rc
WHERE "Numéro de panneau 11" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 12",
"Nuance candidat 12",
"Nom candidat 12",
"Prénom candidat 12",
"Sexe candidat 12",
"Voix 12",
"% Voix/inscrits 12",
"% Voix/exprimés 12",
"Elu 12"
FROM resultats_complets rc
WHERE "Numéro de panneau 12" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 13",
"Nuance candidat 13",
"Nom candidat 13",
"Prénom candidat 13",
"Sexe candidat 13",
"Voix 13",
"% Voix/inscrits 13",
"% Voix/exprimés 13",
"Elu 13"
FROM resultats_complets rc
WHERE "Numéro de panneau 13" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 14",
"Nuance candidat 14",
"Nom candidat 14",
"Prénom candidat 14",
"Sexe candidat 14",
"Voix 14",
"% Voix/inscrits 14",
"% Voix/exprimés 14",
"Elu 14"
FROM resultats_complets rc
WHERE "Numéro de panneau 14" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 15",
"Nuance candidat 15",
"Nom candidat 15",
"Prénom candidat 15",
"Sexe candidat 15",
"Voix 15",
"% Voix/inscrits 15",
"% Voix/exprimés 15",
"Elu 15"
FROM resultats_complets rc
WHERE "Numéro de panneau 15" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 16",
"Nuance candidat 16",
"Nom candidat 16",
"Prénom candidat 16",
"Sexe candidat 16",
"Voix 16",
"% Voix/inscrits 16",
"% Voix/exprimés 16",
"Elu 16"
FROM resultats_complets rc
WHERE "Numéro de panneau 16" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 17",
"Nuance candidat 17",
"Nom candidat 17",
"Prénom candidat 17",
"Sexe candidat 17",
"Voix 17",
"% Voix/inscrits 17",
"% Voix/exprimés 17",
"Elu 17"
FROM resultats_complets rc
WHERE "Numéro de panneau 17" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 18",
"Nuance candidat 18",
"Nom candidat 18",
"Prénom candidat 18",
"Sexe candidat 18",
"Voix 18",
"% Voix/inscrits 18",
"% Voix/exprimés 18",
"Elu 18"
FROM resultats_complets rc
WHERE "Numéro de panneau 18" IS NOT NULL
UNION 
SELECT
id_circo AS circo_id,
dep AS dep_code,
"Numéro de panneau 19",
"Nuance candidat 19",
"Nom candidat 19",
"Prénom candidat 19",
"Sexe candidat 19",
"Voix 19",
"% Voix/inscrits 19",
"% Voix/exprimés 19",
"Elu 19"
FROM resultats_complets rc
WHERE "Numéro de panneau 19" IS NOT NULL;

-- Transformation du champ "elu_e" de textuel à booléen (Vrai/Faux)
ALTER TABLE resultats_par_candidat_e
ADD COLUMN elu_e_bool boolean;

UPDATE resultats_par_candidat_e
SET elu_e_bool = TRUE
WHERE elu_e = 'élu';

ALTER TABLE resultats_par_candidat_e
DROP COLUMN elu_e;

ALTER TABLE resultats_par_candidat_e
RENAME COLUMN elu_e_bool TO elu_e;

-- Suppression des caractères '%' et remplacement des virgules par des points
UPDATE resultats_par_candidat_e
SET rapport_voix_inscrits = REPLACE(rapport_voix_inscrits, '%', ''),
    rapport_voix_exprimes = REPLACE(rapport_voix_exprimes, '%', '');

UPDATE resultats_par_candidat_e
SET rapport_voix_inscrits = REPLACE(rapport_voix_inscrits, ',', '.'),
    rapport_voix_exprimes = REPLACE(rapport_voix_exprimes, ',', '.');

-- Retypage des champs qui représentent des taux d'un type textuel à un type numérique
ALTER TABLE resultats_par_candidat_e
ALTER COLUMN rapport_voix_inscrits TYPE NUMERIC USING rapport_voix_inscrits::numeric;

ALTER TABLE resultats_par_candidat_e
ALTER COLUMN rapport_voix_exprimes TYPE NUMERIC USING rapport_voix_exprimes::numeric;

-- Ajout d'une colonne "nuance_bloc"
ALTER TABLE resultats_par_candidat_e ADD COLUMN nuance_bloc varchar;

UPDATE resultats_par_candidat_e rpc
SET nuance_bloc = nuance.bloc
FROM nuance WHERE nuance.nuance = rpc.nuance_candidat_e;

-- Ajout d'une colonne "position"
ALTER TABLE resultats_par_candidat_e ADD COLUMN "position" integer;

-- Calcul de la position de chaque candidat·e selon les résultats du 1er tour
WITH a AS (
    SELECT 
      circo_id,
      numero_panneau,
      voix,
      nuance_candidat_e,
      ROW_NUMBER () OVER (
      PARTITION BY circo_id
        ORDER BY 
          voix DESC
      )
    FROM 
    resultats_par_candidat_e rpc
)
UPDATE resultats_par_candidat_e rpc
SET "position" = a.ROW_NUMBER
FROM a WHERE a.circo_id = rpc.circo_id AND a.numero_panneau = rpc.numero_panneau;


---- Création d'une table joignant les tables "circo" et "resultats_par_candidat_e"
DROP TABLE IF EXISTS resultats_candidat_es_par_circo;

CREATE TABLE resultats_candidat_es_par_circo
AS SELECT
    circo.circo_id,
    circo.dep_code,
    circo.dep_nom,
    circo.circo_libelle,
    circo.inscriptions,
    circo.votes,
    circo.vote_taux,
    circo.abstentions,
    circo.abstention_taux,
    circo.votes_exprimes,
    circo.taux_votes_exprimes_inscriptions,
    circo.taux_votes_exprimes_votes,
    circo.votes_blancs,
    circo.taux_votes_blancs_inscriptions,
    circo.taux_votes_blancs_votes,
    circo.votes_nuls,
    circo.taux_votes_nuls_inscriptions,
    circo.taux_votes_nuls_votes,
    circo.geom,
    rpce.numero_panneau,
    rpce.nuance_candidat_e,
    rpce.nom_candidat_e,
    rpce.prenom_candidat_e,
    rpce.sexe_candidat_e,
    rpce.voix,
    rpce.rapport_voix_inscrits,
    rpce.rapport_voix_exprimes,
    rpce.elu_e,
    rpce.nuance_bloc,
    rpce."position"
FROM circo JOIN resultats_par_candidat_e rpce ON circo.circo_id = rpce.circo_id AND circo.dep_code = rpce.dep_code;