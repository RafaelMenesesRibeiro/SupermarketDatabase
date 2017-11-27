--c) Quais os produtos (ean) que nunca foram repostos
(select ean from produto)
  except
(select distinct ean from reposicao);

--d) Quais os produtos (ean) com um numero de fornecedores secundarios superiores a 10
select distinct ean
from fornece_sec
group by ean
having count(nif) > 10;
