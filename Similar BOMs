CREATE VIEW [dbo].[Recept_lignende_selfie]
AS
SELECT
	T1.[Production BOM No.]
	,T1.[Version Code]
	,T3.[T3_SUM]
	,T2.[T2_BOM_NO]
	,T2.[T2_Version Code]
	,T4.[T4_SUM]
	,CASE 
	     WHEN
		T3.[T3_SUM] = T4.[T4_SUM]
		     THEN SUM(ABS(T1.[Quantity per] - T2.[T2_QTY]))
	     WHEN
		T3.[T3_SUM] <> T4.[T4_SUM]
		     THEN SUM(ABS(T1.[Quantity per] - T2.[T2_QTY])) + 1000
	     ELSE 9999999
	END
	AS [BOM DIFF]

FROM (
SELECT
	[Production BOM No.]
	,[Version Code]
	,[No.]
	,[Quantity per]
FROM [NAV_dbo_Production BOM Line]
WHERE [Probat vare] = 1
) AS T1

LEFT JOIN (
SELECT
	[Production BOM No.] AS [T2_BOM_NO]
	,[Version Code] AS [T2_Version Code]
	,[No.] AS [T2_NO]
	,[Quantity per] AS [T2_QTY]
FROM [NAV_dbo_Production BOM Line]
WHERE [Probat vare] = 1
) AS T2
ON T1.[Production BOM No.] <> T2.[T2_BOM_NO]
	AND T1.[No.] = T2.[T2_NO]

LEFT JOIN (
SELECT
	[Production BOM No.]
	,[Version Code] AS [T3_Version Code]
	,SUM([Unik nr per varenr]) AS [T3_SUM]
FROM [NAV_dbo_Production BOM Line]
WHERE [Probat vare] = 1
GROUP BY [Production BOM No.], [Version Code]
) AS T3
ON T1.[Production BOM No.] = T3.[Production BOM No.]
	AND T1.[Version Code] = T3.[T3_Version Code]

LEFT JOIN (
SELECT
	[Production BOM No.]
	,[Version Code]  AS [T4_Version Code]
	,SUM([Unik nr per varenr]) AS [T4_SUM]
FROM [NAV_dbo_Production BOM Line]
WHERE [Probat vare] = 1
GROUP BY [Production BOM No.], [Version Code]
) AS T4
ON T2.[T2_BOM_NO] = T4.[Production BOM No.]
	AND T2.[T2_Version Code] = T4.[T4_Version Code]

GROUP BY
	T1.[Production BOM No.]
	,T1.[Version Code]
	,T2.[T2_BOM_NO]
	,T2.[T2_Version Code]
	,T3.[T3_SUM]
	,T4.[T4_SUM]


HAVING T2.[T2_BOM_NO] IS NOT NULL
