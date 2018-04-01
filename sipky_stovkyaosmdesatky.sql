USE sipky;
GO

WITH t AS (
	SELECT ROW_NUMBER() OVER(PARTITION BY id_zapas ORDER BY player ASC) AS rownum
	,id_zapas
	,player
	FROM detaily
	)
, lidskezapasy AS
( SELECT id_zapas
	FROM detaily
	GROUP BY id_zapas
	HAVING COUNT(player) > 1)
, nadhoz AS (
SELECT p.id_zapas
	,p.[1] AS hrac1
	,p.[2] AS hrac2
FROM t
PIVOT
(
	MAX(t.player)
	FOR t.rownum IN ([1], [2])
)
AS p
WHERE p.id_zapas IN (select * from lidskezapasy)
), sranda AS (
SELECT n.id_zapas
		, p1.nickname AS hrac1
		, d.vyhrane_legy AS legy1
		, (d.[100plus] + d.[140plus] + d.[180]) AS stovky1
		, p2.nickname AS hrac2
		, dd.vyhrane_legy AS legy2
		, (dd.[100plus] + dd.[140plus] + dd.[180]) AS stovky2 
		, (d.vyhrane_legy + dd.vyhrane_legy) AS odehranelegy
		, (d.[80plus] + d.[100plus] + d.[140plus] + d.[180] + dd.[80plus] + dd.[100plus] + dd.[140plus] + dd.[180]) AS  osmdesatvice
		, (d.[100plus] + d.[140plus] + d.[180] + dd.[100plus] + dd.[140plus] + dd.[180]) AS stovky 
FROM nadhoz AS n
	INNER JOIN players AS p1
	ON n.hrac1 = p1.p_id
		INNER JOIN players AS p2
		ON n.hrac2 = p2.p_id
			INNER JOIN detaily AS d
			ON n.id_zapas = d.id_zapas
			AND n.hrac1 = d.player
				INNER JOIN detaily AS dd
				ON n.id_zapas = dd.id_zapas 
				AND n.hrac2 = dd.player
)
SELECT id_zapas, odehranelegy, osmdesatvice, CAST(osmdesatvice*1.00/odehranelegy AS numeric(5,2)) AS osmdesatky_na_leg
	, stovky
	, CAST(stovky*1.00/odehranelegy AS numeric(5,2)) AS stovky_na_leg, hrac1, legy1, stovky1, hrac2, legy2, stovky2
FROM sranda 

