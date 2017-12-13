SELECT *
FROM (
	(SELECT count(T.dateid) as count, T.ano, T.mes, P.categoria
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 123455678
	GROUP BY T.ano, T.mes, P.categoria)
UNION
	(SELECT count(T.dateid) as count, T.ano, T.mes, null
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 123455678
	GROUP BY T.ano, T.mes)
UNION
	(SELECT count(T.dateid) as count, T.ano, null, null
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 123455678
	GROUP BY T.ano)
UNION
	(SELECT count(T.dateid) as count, null, null, null
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 123455678)
) as K	
ORDER BY count, K.ano, K.mes, K.categoria;
