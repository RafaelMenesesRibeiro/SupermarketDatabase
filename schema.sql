drop table if exists categoria cascade;
drop table if exists categoria_simples cascade;
drop table if exists super_categoria cascade;
drop table if exists constituida cascade;
drop table if exists produto cascade;
drop table if exists fornecedor cascade;
drop table if exists fornece_sec cascade;
drop table if exists corredor cascade;
drop table if exists prateleira cascade;
drop table if exists planograma cascade;
drop table if exists evento_reposicao cascade;
drop table if exists reposicao cascade;

----------------------------------------
-- Table Creation
----------------------------------------

-- Named CONSTRAINTs are global to the database.
-- Therefore the following use the following naming rules:
--   1. pk_table for names of PRIMARY KEY CONSTRAINTs
--   2. fk_table_aNOTher for names of FOREIGN KEY CONSTRAINTs

CREATE TABLE categoria (
	nome       varchar(80) NOT NULL UNIQUE,
	CONSTRAINT pk_categoria PRIMARY KEY(nome)
	--CONSTRAINT ri_re1 #TODO,
	--CONSTRAINT ri_re2 #TODO
);

CREATE TABLE categoria_simples (
	nome       varchar(80) NOT NULL UNIQUE,
	CONSTRAINT pk_categoria_simples PRIMARY KEY(nome),
	CONSTRAINT fk_categoria_simples FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE super_categoria (
	nome       varchar(80) NOT NULL UNIQUE,
	CONSTRAINT pk_super_categoria PRIMARY KEY(nome),
	CONSTRAINT fk_super_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
	--CONSTRAINT ri_re3 #TODO
);

CREATE TABLE constituida (
	super_categoria   varchar(80) NOT NULL,
	categoria         varchar(80) NOT NULL,
	CONSTRAINT        pk_constituida PRIMARY KEY(super_categoria, categoria),
	CONSTRAINT        fk_constituida_super_categoria FOREIGN KEY(super_categoria) REFERENCES super_categoria(nome),
	CONSTRAINT        fk_constituida_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome),
	--CONSTRAINT        ri_ea1 #TODO,
	CONSTRAINT        ri_re3 CHECK (super_categoria != categoria)
);

CREATE TABLE fornecedor (
	--TODO - ask teacher.
	nif        numeric(9, 0) NOT NULL UNIQUE,
	nome       varchar(80) NOT NULL,
	CONSTRAINT pk_fornecedor PRIMARY KEY(nif),
	CONSTRAINT valid_nif CHECK (nif BETWEEN 100000000 and 999999999)
);

CREATE TABLE produto (
	ean           numeric(13, 0) NOT NULL UNIQUE,
	design        varchar(80) NOT NULL,
	categoria     varchar(80) NOT NULL,
	forn_primario integer NOT NULL,
	data          date NOT NULL,
	CONSTRAINT    pk_produto PRIMARY KEY(ean),
	CONSTRAINT    fk_produto_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome),
	CONSTRAINT    fk_produto_forn_primario FOREIGN KEY(forn_primario) REFERENCES fornecedor(nif),
	--CONSTRAINT    ri_re3 #TODO
	CONSTRAINT valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999),
	CONSTRAINT product_is_nif_sec CHECK ((isNIFSec(ean, forn_primario) = 0))
);

CREATE OR REPLACE FUNCTION isNIFSec(ean numeric, nif integer) RETURNS int as $$
	begin
    return (select count(1) from(select 1 from fornece_sec as S where S.ean = $1 and S.nif = $2) as K);
	end
$$ LANGUAGE 'plpgsql';

CREATE TABLE fornece_sec (
	nif           numeric(9, 0) NOT NULL,
	ean           numeric(13, 0) NOT NULL,
	CONSTRAINT    pk_fornece_sec PRIMARY KEY(nif, ean),
	CONSTRAINT    fk_fornece_sec_nif FOREIGN KEY(nif) REFERENCES fornecedor(nif),
	CONSTRAINT    fk_fornece_sec_ean FOREIGN KEY(ean) REFERENCES produto(ean),
	CONSTRAINT    valid_nif CHECK (nif BETWEEN 100000000 and 999999999),
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999),
	CONSTRAINT 	  fornece_sec_is_nif_prim CHECK ((isNIFPrim(CAST(ean as numeric), CAST(nif as numeric)) = 0))
);

CREATE OR REPLACE FUNCTION isNIFPrim(ean numeric, nif numeric) RETURNS int as $$
	begin
    return (select count(1) from(select 1 from produto as P where P.ean = $1 and P.forn_primario = $2) as K);
	end
$$ LANGUAGE 'plpgsql';

CREATE TABLE corredor (
	nro           integer NOT NULL UNIQUE,
	largura       numeric(3,2) NOT NULL,
	CONSTRAINT    pk_corredor PRIMARY KEY(nro)
);

CREATE TABLE prateleira (
	nro           integer NOT NULL,
	--TODO - add constraint to only be 'esquerda' or 'direita'
	lado          char(8) NOT NULL,
	altura        char(8) NOT NULL,
	CONSTRAINT    pk_prateleira PRIMARY KEY(nro, lado, altura),
	CONSTRAINT    fk_prateleira_nro FOREIGN KEY(nro) REFERENCES corredor(nro)
);

CREATE TABLE planograma(
	ean           numeric(13, 0) NOT NULL,
	nro           integer NOT NULL,
	--TODO - add constraint to only be 'esquerda' or 'direita'
	lado          char(8) NOT NULL,
	--TODO - add constraint to only be 'chao' or 'medio' or 'superior'
	altura        char(8) NOT NULL,
	--TODO - only 4?
	face          integer NOT NULL,
	unidades      integer NOT NULL,
	loc           integer NOT NULL,
	CONSTRAINT    pk_planograma PRIMARY KEY(ean, nro, lado, altura),
	CONSTRAINT    fk_planograma_ean FOREIGN KEY(ean) REFERENCES produto(ean),
	CONSTRAINT    fk_planograma_nro FOREIGN KEY(nro, lado, altura) REFERENCES prateleira(nro, lado, altura),
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999)
);

CREATE TABLE evento_reposicao(
	operador      integer NOT NULL,
	instante      date NOT NULL,
	CONSTRAINT    pk_evento_reposicao PRIMARY KEY(operador, instante)
	--TODO CONSTRAINT    ri_ea3
);

CREATE TABLE reposicao(
	ean           numeric(13, 0) NOT NULL,
	nro           integer NOT NULL,
	--TODO - add constraint to only be 'esquerda' or 'direita'
	lado          char(8) NOT NULL,
	--TODO - add constraint to only be 'chao' or 'medio' or 'superior'
	altura        char(8) NOT NULL,
	operador      integer NOT NULL,
	instante      date NOT NULL,
	unidades      integer NOT NULL,
	CONSTRAINT    pk_reposicao PRIMARY KEY(ean, nro, lado, altura, operador, instante),
	CONSTRAINT    fk_reposicao_ean FOREIGN KEY(ean, nro, lado, altura) REFERENCES planograma(ean, nro, lado, altura),
	CONSTRAINT    fk_reposicao_operador FOREIGN KEY(operador, instante) REFERENCES evento_reposicao(operador, instante),
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999)
);

----------------------------------------
-- Index Creation
----------------------------------------
-- 1) Liste o nif e nome de todos os fornecedores primários da categoria 'Frutos'.
CREATE INDEX product_cat_idx ON produto (categoria);
CREATE UNIQUE INDEX supplier_nif_idx ON fornecedor (nif);
