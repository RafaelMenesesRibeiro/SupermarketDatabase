\echo '..............................'
\echo ''
\echo 'a) Qual o nome do fornecedor que forneceu o maior número de categorias? Note que pode ser mais do que um fornecedor.'
\echo ''
\echo '..............................'
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
			) as produtos;


\echo '..............................'
\echo ''
\echo 'b) Quais of fornecedores primários (nome e nif) que forneceram produtos de todas as categorias simples?'
\echo ''
\echo '..............................'

select P.forn_primario as nif, count(distinct categoria) as unique_cats
from produto as P
group by P.forn_primario
having count(distinct categoria) = (select count(S.nome) from categoria_simples as S);



\echo '..............................'
\echo ''
\echo 'c) Quais os produtos (ean) que nunca foram repostos'
\echo ''
\echo '..............................'

(select ean from produto)
  except
(select distinct ean from reposicao);

\echo '..............................'
\echo ''
\echo 'd) Quais os produtos (ean) com um numero de fornecedores secundarios superiores a 10:'
\echo ''
\echo '..............................'
select distinct ean
from fornece_sec
group by ean
having count(nif) > 10;

\echo '..............................'
\echo ''
\echo 'e) Quais os produtos (ean) que foram repostos sempre pelo mesmo operador?:'
\echo ''
\echo '..............................'
