drop table if exists d_produto CASCADE;
drop table if exists d_tempo CASCADE;
drop table if exists facts CASCADE;

----------------------------------------
-- Dimension Tables Creation
----------------------------------------
CREATE TABLE d_produto (
	ean           numeric(13, 0) NOT NULL UNIQUE,
	categoria     varchar(80) NOT NULL,
	forn_primario integer NOT NULL,
	CONSTRAINT    pk_d_produto PRIMARY KEY(ean),
	CONSTRAINT    fk_d_produto_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome),
	CONSTRAINT    fk_d_produto_forn_primario FOREIGN KEY(forn_primario) REFERENCES fornecedor(nif),
	CONSTRAINT 	  d_valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999)
);

CREATE TABLE d_tempo (
	dia			int NOT NULL,
	mes			int NOT NULL,
	ano			int NOT NULL,
	CONSTRAINT    pk_d_tempo PRIMARY KEY(dia, mes, ano)
);

----------------------------------------
-- Facts Table Creation
----------------------------------------
CREATE TABLE facts (
	ean 		numeric(13, 0) NOT NULL UNIQUE,
	dia			int NOT NULL,
	mes			int NOT NULL,
	ano			int NOT NULL,
	CONSTRAINT    pk_d_facts PRIMARY KEY(ean, dia, mes, ano),
	CONSTRAINT    fk_d_facts_ean FOREIGN KEY(ean) REFERENCES d_produto(ean),
	CONSTRAINT    fk_d_facts_instante FOREIGN KEY(dia, mes, ano) REFERENCES d_tempo(dia, mes, ano)
);

----------------------------------------
-- Data insertion for d_produto
----------------------------------------
INSERT INTO d_produto
SELECT ean, categoria, forn_primario
FROM produto;

----------------------------------------
-- Creates the trigger for d_tempo
----------------------------------------
CREATE OR REPLACE FUNCTION do_d_tempo() RETURNS trigger as $$
	begin
		if (new.dia, new.mes, new.ano) in ( select * from d_tempo)
		then return NULL;
		end if;
		return NEW;
	end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER chk_d_tempo
	before insert or update on d_tempo
	FOR each row execute procedure do_d_tempo()
;

----------------------------------------
-- Data insertion for d_tempo
----------------------------------------
INSERT INTO d_tempo
SELECT 	extract(day FROM instante), 
		extract(month FROM instante),
		extract(year FROM instante)
FROM reposicao;

----------------------------------------
-- Data insertion for facts
----------------------------------------
