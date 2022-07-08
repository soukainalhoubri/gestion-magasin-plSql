drop table ACHAT;
drop table STOCKER;
drop table PRODUIT;
drop table CLIENT;
drop table MAGASIN;
-----------------------
create table MAGASIN
(
idMagasin NUMBER,
nomMagasin VARCHAR(30),
adrMagasin VARCHAR(30),
constraint PK_MAGASIN primary key (IdMagasin)
);------------------------------------------------------
create table CLIENT
(
idCli NUMBER,
nomCli VARCHAR(30),
preCli VARCHAR(30),
adrCli VARCHAR(30),
chAffaire NUMBER(8,2),
idMagasin NUMBER,
constraint PK_CLIENT primary key (idCli),
constraint FK_CLIENT_IdMagasin foreign key (idMagasin)
 references MAGASIN (IdMagasin)
);------------------------------------------------------------------
-
create table PRODUIT
(
idProd NUMBER,
nomProd VARCHAR(30),
puProd NUMBER(8,2),
constraint PK_PRODUIT primary key (idProd)
);-----------------------------------------------------
create table STOCKER
(
idProd NUMBER,
idMagasin NUMBER,
qteStock NUMBER,
constraint PK_STOCKER primary key (idProd, idMagasin),
constraint FK_STOCKER_IdProd foreign key (idProd)
 references PRODUIT (idProd),
constraint FK_STOCKER_IdMagasin foreign key (idMagasin)
 references MAGASIN (idMagasin)
);-----------------------------------------------------------------
create table ACHAT
(
idProd NUMBER,
idMagasin NUMBER,
idCli NUMBER,
idDateA DATE,
qteAchat NUMBER,
prixPaye NUMBER(8,2),
constraint PK_ACHAT primary key (idProd, idMagasin, idCli,
idDateA),
constraint FK_ACHAT_IdProdIdMagasin foreign key (idProd, idMagasin)
 references STOCKER (idProd,
idMagasin),
constraint FK_ACHAT_IdCli foreign key (idCli)
 references CLIENT (idCli)
);
---------------------------
drop sequence SEQ_CLIENT;
drop sequence SEQ_PRODUIT;
create sequence SEQ_CLIENT start with 1 increment by 1;
create sequence SEQ_PRODUIT start with 1 increment by 1;
-----------------------------------------------------------------
insert into MAGASIN values (1,'Home Picsou','Rue Donald');
insert into MAGASIN values (2,'Pic Poket', 'Avenue Arsene Lupin');
insert into CLIENT values
(SEQ_CLIENT.nextval,'Aztakes','Helene','Toulouse',NULL,NULL);
insert into CLIENT values (SEQ_CLIENT.nextval,'Du
Semefier','Honore','Toulouse',NULL,NULL);
insert into CLIENT values
(SEQ_CLIENT.nextval,'Nette','Mario','Paris',NULL,NULL);
insert into PRODUIT values (SEQ_PRODUIT.nextval,'Produit 1',100.00);
insert into STOCKER values (SEQ_PRODUIT.currval,1, 5);
insert into STOCKER values (SEQ_PRODUIT.currval,2, 3);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,1,'10/02/2012',2,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,2,'10/02/2012',1,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,3,'11/02/2012',3,NULL);
insert into PRODUIT values (SEQ_PRODUIT.nextval,'Produit 2', 50.00);
insert into STOCKER values (SEQ_PRODUIT.currval,1, 8);
insert into STOCKER values (SEQ_PRODUIT.currval,2,10);
insert into ACHAT values
(SEQ_PRODUIT.currval,2,2,'09/02/2012',1,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,3,'10/02/2012',2,NULL);
insert into PRODUIT values (SEQ_PRODUIT.nextval,'Produit 3',120.00);
insert into STOCKER values (SEQ_PRODUIT.currval,1,12);
insert into STOCKER values (SEQ_PRODUIT.currval,2, 8);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,1,'11/02/2012',3,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,3,'12/02/2012',2,NULL);
insert into PRODUIT values (SEQ_PRODUIT.nextval,'Produit 4', 70.00);
insert into STOCKER values (SEQ_PRODUIT.currval,1, 2);
insert into STOCKER values (SEQ_PRODUIT.currval,2, 0);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,3,'10/02/2012',2,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,1,'09/02/2012',2,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,2,'11/02/2012',2,NULL);
insert into PRODUIT values (SEQ_PRODUIT.nextval,'Produit 5', 50.00);
insert into STOCKER values (SEQ_PRODUIT.currval,1,15);
insert into STOCKER values (SEQ_PRODUIT.currval,2,25);
insert into ACHAT values
(SEQ_PRODUIT.currval,1,1,'13/02/2012',1,NULL);
insert into ACHAT values
(SEQ_PRODUIT.currval,2,2,'09/02/2012',4,NULL);
commit;
update ACHAT a
set prixPaye = (select puProd*a.qteAchat
 from PRODUIT
 where idProd = a.idProd);
update CLIENT c
set chAffaire = (select SUM(prixPaye)
 from ACHAT
where idCli = c.idCli),
 idMagasin = (select distinct idMagasin
 from ACHAT a
 where idCli = c.idCli
 and idDateA = (select MIN(idDateA)
 from ACHAT
where idCli = a.idCli));
commit;