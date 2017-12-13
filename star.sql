drop table if exists d_produto CASCADE;
drop table if exists d_tempo CASCADE;
drop table if exists facts CASCADE;

----------------------------------------
-- Dimension Tables Creation
----------------------------------------
CREATE TABLE d_produto (
	ean           numeric(13, 0) NOT NULL,
	categoria     varchar(80) NOT NULL,
	forn_primario integer NOT NULL,
	CONSTRAINT    pk_d_produto PRIMARY KEY(ean),
	CONSTRAINT    fk_d_produto FOREIGN KEY(ean) REFERENCES produto(ean)
);

CREATE TABLE d_tempo (
	dateid 		int NOT NULL,
	dia			int NOT NULL,
	mes			int NOT NULL,
	ano			int NOT NULL,
	CONSTRAINT  pk_d_tempo PRIMARY KEY(dateid)
);

----------------------------------------
-- Facts Table Creation
----------------------------------------
CREATE TABLE facts (
	ean 		numeric(13, 0) NOT NULL,
	dateid		int NOT NULL,
	unidades 	int NOT NULL,
	CONSTRAINT  pk_d_facts PRIMARY KEY(ean, dateid),
	CONSTRAINT  fk_d_facts_ean FOREIGN KEY(ean) REFERENCES d_produto(ean),
	CONSTRAINT  fk_d_facts_dateid FOREIGN KEY(dateid) REFERENCES d_tempo(dateid)
);

