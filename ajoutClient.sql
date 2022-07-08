/*description de la procédure:

- Paramètres en Entrée : tous les attributs de la table CLIENT (sauf idCli).
- Action : Insertion du nouveau client dans la table CLIENT.
- Exceptions : idMagasin # 1 ou 2.
- Affichages : Client crée ou magasin inconnu

*/

CREATE OR REPLACE PROCEDURE AJOUT_CLIENT

(nom IN CLIENT.nomCli%TYPE, prenom IN CLIENT.preCli%TYPE, addresse IN CLIENT.adrCli%TYPE, chiffre IN CLIENT.chAffaire%TYPE, magasin IN CLIENT.idMagasin%TYPE)

IS
error1 EXCEPTION;
error2 EXCEPTION;
maxi CLIENT.idMagasin%TYPE;

BEGIN

IF magasin=1 OR magasin=2 THEN 
RAISE error1;
END IF;

SELECT MAX(idMagasin) INTO maxi FROM MAGASIN ;

IF magasin>maxi THEN 
RAISE error2;
END IF;
INSERT INTO CLIENT (idCli,nomCli,preCli,adrCli,chAffaire,idMagasin)
VALUES (SEQ_CLIENT.nextval, nom,prenom,addresse, chiffre, magasin);

DBMS_OUTPUT.PUT_LINE('insertion effectuée avec succès') ;


EXCEPTION
 WHEN error1 THEN DBMS_OUTPUT.PUT_LINE('vous ne pouvez pas utiliser le magasin 1 ou 2');
 WHEN error2 THEN DBMS_OUTPUT.PUT_LINE('Magasin non trouvé!');

END AJOUT_CLIENT;