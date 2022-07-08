/* description procédure ajout stock:
Paramètres en Entrée : tous les attributs de la table STOCKER.
- Action : Insertion du nouveau couple idProd-idMagasin dans STOCKER.
- Exceptions :
   (1) idProd ou idMagasin inconnu.
   (2) le couple idProd-idMagasin est déjà présent : MAJ de qteStock.
- Affichages : Ajout de stock effectuée (compte rendu exact) ou erreur exception
*/

CREATE OR REPLACE PROCEDURE AJOUT_STOCK
(produit IN STOCKER.idProd%TYPE,magasin IN STOCKER.idMagasin%TYPE,quantite  IN STOCKER.qteStock%TYPE)

IS 
errorInconnuId EXCEPTION;
errorInconnuMag EXCEPTION;
cas Number(1);
BEGIN

SELECT CASE 
       WHEN NOT EXISTS(SELECT idMagasin FROM MAGASIN WHERE idMagasin=magasin)
       THEN 1
       WHEN NOT EXISTS(SELECT idProd FROM PRODUIT WHERE idProd=produit) 
       THEN 2
       WHEN EXISTS(SELECT idMagasin,idProd FROM STOCKER WHERE idMagasin=magasin AND idProd=produit )
       THEN 3
       ELSE 0
       END INTO cas
       FROM DUAL;


IF cas=2 THEN 
RAISE errorInconnuId;
ELSE IF  cas=1 THEN 
RAISE errorInconnuMag;
END IF;

IF cas=3 THEN 

UPDATE STOCKER 
SET qteStock=qteStock+quantite
WHERE idMagasin=magasin AND idProd=produit;

RETURN;


END IF;
INSERT INTO STOCKER (idProd, idMagasin,qteStock) VALUES (produit,magasin,quantite);
DBMS_OUTPUT.PUT_LINE('insertion effectuée avec succès');

END IF;
EXCEPTION
WHEN errorInconnuId THEN DBMS_OUTPUT.PUT_LINE('identifiant produit non trouvé!');
WHEN errorInconnuMag THEN DBMS_OUTPUT.PUT_LINE('identifiant magasin non trouvé!');

END AJOUT_STOCK;