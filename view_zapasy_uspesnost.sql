USE sipky;
GO

/*
			Datum:			2018/04/01
								
			Zobrazuje:
							Pocet legu planovanych
							Pocet legu odehranych
							Hrac 1
							Legy hrace 1
							Hrac 2
							Legy hrace 2
							Vitezny hrac
							Pocet her viteze (kumul)
							Pocet vyher viteze (kumul)
							Uspesnost viteze (kumul)

			Ñezobrazuje:	Legy CPU oponenta
							Odehrane legy proti CPU oponentovi
							Jsem lenoch 
*/


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
SELECT z.id_zapas
	, z.datum
	, z.pocet_legu
	, SUM(d.vyhrane_legy + dd.vyhrane_legy) OVER(PARTITION BY z.id_zapas) AS odehrane_legy
	, p.nickname AS hrac1
	, d.vyhrane_legy AS legy1
	, pp.nickname AS hrac2
	, dd.vyhrane_legy AS legy2
	, ppp.nickname AS vitez
	, ph.pocetherviteze
	, COUNT(ppp.nickname) OVER(PARTITION BY result ORDER BY z.datum ASC, z.id_zapas ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pocetvyherviteze

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
					LEFT OUTER JOIN detaily AS d
					ON z.id_zapas = d.id_zapas
					AND z.player1 = d.player
						LEFT OUTER JOIN detaily AS dd
						ON z.id_zapas = dd.id_zapas
						AND z.player2 = dd.player
)
SELECT *, CONCAT(CAST(pocetvyherviteze*100.0/pocetherviteze AS numeric(5,2)), ' %') AS uspesnost
FROM vyhranezapasy
;



