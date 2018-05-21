-- Titre             : Script SQL (PostgreSQL) de création de la base de données du projet bibliothèque
-- Version           : 1.0
-- Date création     : 07 mars 2006
-- Date modification : 21 avril 2018
-- Auteur            : Philippe TANGUY
-- Editeurs 		 : Alban GOUGOUA & Henri-Michel KOUASSI
-- Description       : Ce script est une ébauche, à compléter, qui permet la création de la table
--                     "livre" pour la réalisation de la fonctionnalité "liste de tous les livres".

-- +----------------------------------------------------------------------------------------------+
-- | Suppression des tables                                                                       |
-- +----------------------------------------------------------------------------------------------+

drop table if exists "livre";
drop table if exists "exemplaire";
drop table if exists "abonne";
drop table if exists "emprunt";

-- +----------------------------------------------------------------------------------------------+
-- | Création des tables                                                                          |
-- +----------------------------------------------------------------------------------------------+

create table livre
(
  id     serial primary key,
  isbn10 varchar(25) unique,
  isbn13 varchar(25) unique,
  titre  varchar(50) not null,
  auteur varchar(30)
);

create table exemplaire
(
  id		serial	primary key,
  id_livre	integer,
  foreign key (id_livre) references livre (id)
);

create table abonne
(
  id		serial 		primary key,
  nom		varchar(15) not null,
  prenom	varchar(50),
  statut	varchar(15) not null,
  email		varchar(50)
);

create table emprunt
(
  id_exemplaire		integer,
  id_abonne			integer,
  date_emprunt		timestamp,
  date_retour		timestamp,
  primary key (id_exemplaire, id_abonne, date_emprunt),
  foreign key (id_exemplaire) references exemplaire (id),
  foreign key (id_abonne) references abonne (id)
);

-- +----------------------------------------------------------------------------------------------+
-- | Insertion de quelques données de pour les tests                                              |
-- +----------------------------------------------------------------------------------------------+

insert into livre values(nextval('livre_id_seq'), '2-84177-042-7', NULL,                'JDBC et JAVA',                            'George REESE');    -- id = 1
insert into livre values(nextval('livre_id_seq'), NULL,            '978-2-7440-7222-2', 'Sociologie des organisations',            'Michel FOUDRIAT'); -- id = 2
insert into livre values(nextval('livre_id_seq'), '2-212-11600-4', '978-2-212-11600-7', 'Le data warehouse',                       'Ralph KIMBALL');   -- id = 3
insert into livre values(nextval('livre_id_seq'), '2-7117-4811-1', NULL,                'Entrepots de données',                    'Ralph KIMBALL');   -- id = 4
insert into livre values(nextval('livre_id_seq'), '2012250564',    '978-2012250567',    'Oui-Oui et le nouveau taxi',              'Enid BLYTON');     -- id = 5
insert into livre values(nextval('livre_id_seq'), '2203001011',    '978-2203001015',    'Tintin au Congo',                         'HERGÉ');           -- id = 6
insert into livre values(nextval('livre_id_seq'), '2012011373',    '978-2012011373',    'Le Club des Cinq et le trésor de l''île', 'Enid BLYTON');     -- id = 7

insert into exemplaire values(nextval('exemplaire_id_seq'), 1);		-- id = 1

insert into abonne values(nextval('abonne_id_seq'), 'GOUGOUA',		'Alban',		'Etudiant',		'alban.gougoua@imt-atlantique.net');		-- id = 1
insert into abonne values(nextval('abonne_id_seq'), 'KOUASSI',		NULL,			'Etudiant',		NULL);										-- id = 2
