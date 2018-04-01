USE sipky;
GO


CREATE VIEW vyhry_prohry_agregat
AS

WITH t AS (
SELECT id_zapas, player1 AS player, result
FROM zapas

UNION 

SELECT id_zapas, player2 AS player, result
FROM zapas
)
, tt AS (

SELECT p.nickname, typ.typ_hry,  COUNT(t.id_zapas) AS zapasy
	, SUM(CASE WHEN t.result = t.player THEN 1 ELSE 0 END) AS vyhry
	, SUM(CASE WHEN t.result <> t.player THEN 1 ELSE 0 END) AS prohry
FROM t
	INNER JOIN players AS p
	ON t.player = p.p_id
		INNER JOIN zapas AS z
		ON t.id_zapas = z.id_zapas
			INNER JOIN typ_hry AS typ
			ON z.typ_hry = typ.id_hra
GROUP BY p.nickname, typ.typ_hry
)
SELECT *, CONCAT(CAST(vyhry*100.00/zapasy AS numeric(5,2)), ' %') AS uspesnost
FROM tt
;