--a) Qual o nome do fornecedor que forneceu o maior número de categorias?
--   Note que pode ser mais do que um fornecedor.
select *
from (
	select max(forn_num.cat_num) as cat_num
	from(
		select count(forn_cat.categoria) as cat_num
		from (
			select P.forn_primario as nif, P.categoria as categoria
			from produto as P
			union
			select S.nif as nif, P.categoria as categoria
			from fornece_sec as S natural join produto as P
		) as forn_cat
		group by forn_cat.nif
	) as forn_num
) as max_num natural join (
							select forn_cat.nif, count(forn_cat.categoria) as cat_num
							from (
								select P.forn_primario as nif, P.categoria as categoria
								from produto as P
								union
								select S.nif as nif, P.categoria as categoria
								from fornece_sec as S natural join produto as P
							) as forn_cat
							group by forn_cat.nif
			) as produtos

--c) Quais os produtos (ean) que nunca foram repostos
(select ean from produto)
  except
(select distinct ean from reposicao);

--d) Quais os produtos (ean) com um numero de fornecedores secundarios superiores a 10
select distinct ean
from fornece_sec
group by ean
having count(nif) > 10;

