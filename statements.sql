drop table categoria cascade;
drop table categoria_simples cascade;
drop table super_categoria cascade;
drop table constituida cascade;
drop table produto cascade;
drop table fornecedor cascade;
drop table fornece_sec cascade;
drop table corredor cascade;
drop table prateleira cascade;
drop table planograma cascade;
drop table evento_reposicao cascade;
drop table reposicao cascade;

----------------------------------------
-- Table Creation
----------------------------------------

-- Named CONSTRAINTs are global to the database.
-- Therefore the following use the following naming rules:
--   1. pk_table for names of PRIMARY KEY CONSTRAINTs
--   2. fk_table_aNOTher for names of FOREIGN KEY CONSTRAINTs

CREATE TABLE categoria (
	nome       varchar(80)  NOT NULL UNIQUE,
	CONSTRAINT pk_categoria PRIMARY KEY(nome),
	CONSTRAINT ri_re1 #TODO,
	CONSTRAINT ri_re2 #TODO
);

CREATE TABLE categoria_simples (
	nome       varchar(80) NOT NULL UNIQUE,
	CONSTRAINT pk_categoria_simples PRIMARY KEY(nome),
	CONSTRAINT fk_categoria_simples FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE super_categoria (
	nome       varchar(80) NOT NULL UNIQUE,
	CONSTRAINT pk_super_categoria PRIMARY KEY(nome),
	CONSTRAINT fk_super_categoria FOREIGN KEY(nome) REFERENCES categoria(nome),
	CONSTRAINT ri_re3 #TODO
);

CREATE TABLE constituida (
	super_categoria   varchar(80) NOT NULL UNIQUE,
	categoria           varchar(80)   NOT NULL UNIQUE,
	CONSTRAINT        pk_constituida PRIMARY KEY(super_categoria, categoria),
	CONSTRAINT        fk_constituida_super_categoria FOREIGN KEY(super_categoria) REFERENCES super_categoria(nome),
	CONSTRAINT        fk_constituida_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome),
	CONSTRAINT        ri_ea1 #TODO,
	CONSTRAINT        super_categoria != categoria
);

CREATE TABLE produto (
	#TODO - change to numeric.
	ean           bigint(13)  NOT NULL UNIQUE,
	design        varchar(80) NOT NULL,
	categoria     varchar(80) NOT NULL,
	forn_primario integer(9)  NOT NULL,
	data          date        NOT NULL,
	CONSTRAINT    pk_produto PRIMARY KEY(ean),
	#TODO - change to numeric.
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999),
	CONSTRAINT    fk_produto_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome),
	CONSTRAINT    fk_produto_forn_primario FOREIGN KEY(forn_primario) REFERENCES fornecedor(nif),
	CONSTRAINT    ri_re3 #TODO
);

CREATE TABLE fornecedor (
	#TODO - ask teacher.
	nif        integer(9)  NOT NULL UNIQUE,
	nome       varchar(80) NOT NULL,
	CONSTRAINT pk_fornecedor PRIMARY KEY(nif)
);

CREATE TABLE fornece_sec (
	nif           integer(9)  NOT NULL UNIQUE,
	#TODO - change to numeric.
	ean           bigint(13)  NOT NULL UNIQUE,
	CONSTRAINT    pk_fornece_sec PRIMARY KEY(nif),
	#TODO - change to numeric.
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999),
	CONSTRAINT    fk_fornece_sec_nif FOREIGN KEY(nif) REFERENCES fornecedor(nif),
	CONSTRAINT    fk_fornece_sec_ean FOREIGN KEY(ean) REFERENCES produto(ean),
	CONSTRAINT    ri_ea4 #TODO
);

CREATE TABLE corredor (
	nro           integer  NOT NULL UNIQUE,
	largura       numeric(3,2)  NOT NULL,
	CONSTRAINT    pk_corredor PRIMARY KEY(nro)
);

CREATE TABLE prateleira (
	#TODO - check if unique is needed
	nro           integer  NOT NULL,
	#TODO - add constraint to only be 'esquerda' or 'direita'
	lado          char(8)  NOT NULL,
	altura        char(8)  NOT NULL,
	CONSTRAINT    pk_corredor PRIMARY KEY(nro, lado, altura),
	CONSTRAINT    fk_prateleira_nro FOREIGN KEY(nro) REFERENCES corredor(nro)
);

CREATE TABLE planograma(
	#TODO - change to numeric.
	ean           bigint(13)  NOT NULL UNIQUE,
	nro           integer  NOT NULL,
	#TODO - add constraint to only be 'esquerda' or 'direita'
	lado          char(8)  NOT NULL,
	#TODO - add constraint to only be 'chao' or 'medio' or 'superior'
	altura        char(8)  NOT NULL,
	#TODO - only 4?
	face          integer  NOT NULL,
	unidades      integer  NOT NULL,
	loc           integer  NOT NULL,
	#TODO - change to numeric.
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999),
	CONSTRAINT    pk_planograma PRIMARY KEY(ean, nro, lado, altura),
	CONSTRAINT    fk_planograma_ean FOREIGN KEY(ean) REFERENCES produto(ean),
	CONSTRAINT    fk_planograma_nro FOREIGN KEY(nro) REFERENCES prateleira(nro),
	CONSTRAINT    fk_planograma_lado FOREIGN KEY(lado) REFERENCES prateleira(lado),
	CONSTRAINT    fk_planograma_altura FOREIGN KEY(altura) REFERENCES prateleira(altura)
);

CREATE TABLE evento_reposicao(
	operador      integer(9)  NOT NULL,
	instante      date  NOT NULL,
	CONSTRAINT    pk_evento_reposicao PRIMARY KEY(operador, instante)
	CONSTRAINT    ri_ea3 #TODO
);

CREATE TABLE reposicao(
	#TODO - change to numeric.
	ean           bigint(13)  NOT NULL,
	nro           integer  NOT NULL,
	#TODO - add constraint to only be 'esquerda' or 'direita'
	lado          char(8)  NOT NULL,
	#TODO - add constraint to only be 'chao' or 'medio' or 'superior'
	altura        char(8)  NOT NULL,
	operador      integer(9)  NOT NULL, 
	instante      date  NOT NULL,
	unidades      integer  NOT NULL,
	#TODO - change to numeric.
	CONSTRAINT    valid_ean CHECK (ean BETWEEN 1000000000000 and 9999999999999),
	CONSTRAINT    pk_reposicao PRIMARY KEY(ean, nro, lado, altura, operador, instante),
	CONSTRAINT    fk_reposicao_ean FOREIGN KEY(ean) REFERENCES planograma(ean),
	CONSTRAINT    fk_reposicao_nro FOREIGN KEY(nro) REFERENCES planograma(nro),
	CONSTRAINT    fk_reposicao_lado FOREIGN KEY(lado) REFERENCES planograma(lado),
	CONSTRAINT    fk_reposicao_altura FOREIGN KEY(altura) REFERENCES planograma(altura),
	CONSTRAINT    fk_reposicao_operador FOREIGN KEY(operador) REFERENCES evento_reposicao(operador),
	CONSTRAINT    fk_reposicao_instante FOREIGN KEY(instante) REFERENCES evento_reposicao(instante)

);
----------------------------------------
-- Populate Relations
----------------------------------------

insert into customer values ('Adams',   'Main Street',  'Lisbon');
insert into customer values ('Brown',   'Main Street',  'Oporto');
insert into customer values ('Cook',    'Main Street',  'Lisbon');
insert into customer values ('Davis',   'Church Street','Oporto');
insert into customer values ('Evans',   'Forest Street','Coimbra');
insert into customer values ('Flores',  'Station Street','Braga');
insert into customer values ('Gonzalez','Sunny Street', 'Faro');
insert into customer values ('Iacocca', 'Spring Steet', 'Coimbra');
insert into customer values ('Johnson', 'New Street',   'Cascais');
insert into customer values ('King',    'Garden Street','Aveiro');
insert into customer values ('Lopez',   'Grand Street', 'Vila Real');
insert into customer values ('Martin',  'Royal Street', 'Braga');
insert into customer values ('Nguyen',  'School Street','Castelo Branco');
insert into customer values ('Oliver',  'First Stret',  'Oporto');
insert into customer values ('Parker',  'Hope Street',  'Oporto');

insert into branch values ('Downtown',  'Lisbon',       1900000);
insert into branch values ('Central',   'Cascais',      2100000);
insert into branch values ('Uptown',    'Amadora',      1700000);
insert into branch values ('Metro', 'Amadora',      400200);
insert into branch values ('Round Hill','Amadora',      8000000);
insert into branch values ('Ship Terminal', 'Sintra',       0400000);
insert into branch values ('Bolsa',  'Oporto',      3900000);
insert into branch values ('University',    'Vila Real',    7200000);
insert into branch values ('Wine Celar', 'Oporto',      4002800);

insert into account values ('A-101',    'Downtown', 500);
insert into account values ('A-215',    'Metro',    600);
insert into account values ('A-102',    'Uptown',   700);
insert into account values ('A-305',    'Round Hill',   800);
insert into account values ('A-201',    'Uptown',   900);
insert into account values ('A-222',    'Central',  550);
insert into account values ('A-217',    'University',   650);
insert into account values ('A-333',    'Central',  750);
insert into account values ('A-444',    'Downtown', 850);

insert into depositor values ('Johnson', 'A-101');
insert into depositor values ('Brown',   'A-215');
insert into depositor values ('Cook',    'A-102');
insert into depositor values ('Cook',    'A-101');
insert into depositor values ('Flores',  'A-305');
insert into depositor values ('Johnson', 'A-201');
insert into depositor values ('Iacocca', 'A-217');
insert into depositor values ('Evans',   'A-222');
insert into depositor values ('Oliver',  'A-333');
insert into depositor values ('Brown',   'A-444');

insert into loan values ('L-17', 'Downtown',    1000);
insert into loan values ('L-23', 'Central', 2000);
insert into loan values ('L-15', 'Uptown',  3000);
insert into loan values ('L-14', 'Downtown',    4000);
insert into loan values ('L-93', 'Metro',   5000);
insert into loan values ('L-11', 'Round Hill',  6000);
insert into loan values ('L-16', 'Uptown',  7000);
insert into loan values ('L-20', 'Downtown',    8000);
insert into loan values ('L-21', 'Central', 9000);

insert into borrower values ('Iacocca', 'L-17');
insert into borrower values ('Brown',   'L-23');
insert into borrower values ('Cook',    'L-15');
insert into borrower values ('Nguyen',  'L-14');
insert into borrower values ('Davis',   'L-93');
insert into borrower values ('Brown',   'L-11');
insert into borrower values ('Gonzalez','L-17');
insert into borrower values ('Iacocca', 'L-16');
insert into borrower values ('Parker',  'L-20');
insert into borrower values ('Brown',   'L-21');
