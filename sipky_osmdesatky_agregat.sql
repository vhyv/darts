USE sipky;
GO

WITH lidskezapasy AS
( SELECT id_zapas
	FROM detaily
	GROUP BY id_zapas
	HAVING COUNT(player) > 1)
, celkemlegy AS (
		SELECT id_zapas, SUM(vyhrane_legy) AS odehranelegy
		FROM detaily
		GROUP BY id_zapas
		)
, aha AS (
SELECT p.nickname AS player, SUM(c.odehranelegy) AS odehranelegy,
		SUM([80plus] + [100plus] + [140plus] + [180]) AS osmdesatky, SUM([100plus] + [140plus] + [180]) AS stovky
FROM detaily AS d
	INNER JOIN celkemlegy AS c
	ON d.id_zapas = c.id_zapas
		INNER JOIN players AS p
		ON d.player = p.p_id
WHERE d.id_zapas IN (SELECT * FROM lidskezapasy)
GROUP BY p.nickname
)

SELECT player, odehranelegy, osmdesatky
	, CAST(osmdesatky*1.00/odehranelegy AS numeric(5,3)) AS osmdesatplusnaleg
	, stovky
	, CAST(stovky*1.00/odehranelegy AS numeric(5,3)) AS stovkyplusnaleg
FROM aha;

