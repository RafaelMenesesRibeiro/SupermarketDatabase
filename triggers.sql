-- a) O fornecedor (primário) de um produto não pode existir na relação 
--	  fornece_sec para o mesmo produto.
CREATE OR REPLACE FUNCTION do_produto() RETURNS trigger as $$
	begin
		if new.forn_primario in (
			select nif
			from fornece_sec
			where ean = new.ean
		) then
			RAISE EXCEPTION 'The primary supplier given is already a secondary supplier for this product. This cannot happen.';
		end if;

		return NEW;
	end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER chk_produto
	before insert or update on produto
	FOR each row execute procedure do_produto()
;

-- b) O instante mais recente de reposição tem de ser sempre anterior ou igual 
--	  à data atual.
CREATE OR REPLACE FUNCTION do_reposicao() RETURNS trigger as $$
	begin
		if new.instante > current_timestamp then
			RAISE EXCEPTION 'The restocking instant given is in the future. This cannot happen.';
		end if;

		return NEW;
	end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER chk_reposicao
	before insert or update on reposicao
	FOR each row execute procedure do_reposicao()
;

----------------------------------------
-- Creates the trigger for d_tempo
----------------------------------------
CREATE OR REPLACE FUNCTION do_d_tempo() RETURNS trigger as $$
	begin
		if new.dateid in (select dateid from d_tempo)
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
-- Creates the trigger for facts
----------------------------------------
CREATE OR REPLACE FUNCTION do_facts() RETURNS trigger as $$
	begin
		if (new.ean, new.dateid) in (select * from facts)
		then return NULL;
		end if;
		return NEW;
	end;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER chk_facts
	before insert or update on facts
	FOR each row execute procedure do_facts()
;