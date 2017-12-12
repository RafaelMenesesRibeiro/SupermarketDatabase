SELECT *
FROM (
	(SELECT T.ano, T.mes, P.categoria, count(T.dateid) as count
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 267081367
	GROUP BY T.ano, T.mes, P.categoria)
UNION
	(SELECT T.ano, T.mes, null, count(T.dateid) as count
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 267081367
	GROUP BY T.ano, T.mes)
UNION
	(SELECT T.ano, null, null, count(T.dateid) as count
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 267081367
	GROUP BY T.ano)
UNION
	(SELECT null, null, null, count(T.dateid) as count
	FROM facts as F natural join d_produto as P natural join d_tempo as T
	WHERE P.forn_primario = 267081367)
) as K	
ORDER BY count;
