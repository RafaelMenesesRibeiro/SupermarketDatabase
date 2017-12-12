----------------------------------------
-- Data insertion for d_produto
----------------------------------------
INSERT INTO d_produto
SELECT ean, categoria, forn_primario
FROM produto;

----------------------------------------
-- Data insertion for d_tempo
----------------------------------------
----------------------------------------
-- The trigger for duplicate keys is
-- in trigger.sql
----------------------------------------
INSERT INTO d_tempo
SELECT 	to_char(instante, 'YYYYMMDD')::integer,
		extract(day FROM instante), 
		extract(month FROM instante),
		extract(year FROM instante)
FROM reposicao;

----------------------------------------
-- Data insertion for facts
----------------------------------------
----------------------------------------
-- The trigger for duplicate keys is
-- in trigger.sql
----------------------------------------
INSERT INTO facts
SELECT 	R.ean, to_char(R.instante, 'YYYYMMDD')::integer
FROM reposicao as R;