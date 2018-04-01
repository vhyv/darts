USE sipky;
GO


CREATE VIEW zapasy_uspesnost
AS
WITH t AS (
	SELECT player1 AS player, datum, id_zapas
	FROM zapas

	UNION ALL

	SELECT player2 AS player, datum, id_zapas
	FROM zapas
	)
, pocether AS (
SELECT player, datum, id_zapas
	,COUNT(id_zapas) OVER(PARTITION BY player ORDER BY datum ASC, id_zapas ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pocetherviteze
FROM t

)
, vyhranezapasy AS (
SELECT z.id_zapas, z.datum, p.nickname AS hrac1, pp.nickname AS hrac2, ppp.nickname AS vitez, ph.pocetherviteze
, COUNT(ppp.nickname) OVER(PARTITION BY result ORDER BY z.datum ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pocetvyherviteze

FROM zapas AS z
	INNER JOIN players AS p
	ON z.player1 = p.p_id
		INNER JOIN players AS pp
		ON z.player2 = pp.p_id
			INNER JOIN players AS ppp
			ON z.result = ppp.p_id
				INNER JOIN pocether AS ph
				ON z.result = ph.player
				AND z.datum = ph.datum
				AND z.id_zapas = ph.id_zapas
)
SELECT *, CONCAT(CAST(pocetvyherviteze*100.0/pocetherviteze AS numeric(5,2)), ' %') AS uspesnost
FROM vyhranezapasy
;



