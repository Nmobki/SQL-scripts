CREATE VIEW [dbo].[Salgsbudget2018_unpivot]
AS
SELECT
	Deb.[Debitor No]
	,Bud.*
	,CAST(
        CASE 
         WHEN [MånedKort] = 'Jan' THEN '2018-01-01'
         WHEN [MånedKort] = 'Feb' THEN '2018-02-01'
         WHEN [MånedKort] = 'Mar' THEN '2018-03-01'
         WHEN [MånedKort] = 'Apr' THEN '2018-04-01'
         WHEN [MånedKort] = 'Maj' THEN '2018-05-01'
         WHEN [MånedKort] = 'Jun' THEN '2018-06-01'
         WHEN [MånedKort] = 'Jul' THEN '2018-07-01'
         WHEN [MånedKort] = 'Aug' THEN '2018-08-01'
         WHEN [MånedKort] = 'Sep' THEN '2018-09-01'
         WHEN [MånedKort] = 'Okt' THEN '2018-10-01'
         WHEN [MånedKort] = 'Nov' THEN '2018-11-01'
         WHEN [MånedKort] = 'Dec' THEN '2018-12-01'
       END 
       AS DATETIME) AS [Dato]
FROM [Salgsbudget2018_budgetkunder] AS Deb


LEFT JOIN (
SELECT
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[DB]
	,0 AS [KG]
	,0 AS [OMS]
	,0 AS [STK]
	,0 AS [DB kaffe]
	,0 AS [DB non-kaffe]
	,SUBSTRING([Måned],3,3) AS [MånedKort]
FROM (
SELECT 
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[DBJan]
	,[DBFeb]
	,[DBApr]
	,[DBMar]
	,[DBMaj]
	,[DBJun]
	,[DBJul]
	,[DBAug]
	,[DBSep]
	,[DBOkt]
	,[DBNov]
	,[DBDec]
FROM [Salgsbudget2017_Salgsbudget 2018$]) AS Master
UNPIVOT
(DB FOR Måned IN
	([DBJan]
	,[DBFeb]
	,[DBApr]
	,[DBMar]
	,[DBMaj]
	,[DBJun]
	,[DBJul]
	,[DBAug]
	,[DBSep]
	,[DBOkt]
	,[DBNov]
	,[DBDec])
)AS DB

UNION ALL

SELECT
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,0 AS [DB]
	,[KG]
	,0 AS [OMS]
	,0 AS [STK]
	,0 AS [DB kaffe]
	,0 AS [DB non-kaffe]
	,SUBSTRING([Måned],3,3) AS [MånedKort]
FROM (
SELECT 
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[KgJan]
	,[KgFeb]
	,[KgMar]
	,[KgApr]
	,[KgMaj]
	,[KgJun]
	,[KgJul]
	,[KgAug]
	,[KgSep]
	,[KgOkt]
	,[KgNov]
	,[KgDec]
FROM [Salgsbudget2017_Salgsbudget 2018$]) AS Master
UNPIVOT
(KG FOR Måned IN
	([KgJan]
	,[KgFeb]
	,[KgMar]
	,[KgApr]
	,[KgMaj]
	,[KgJun]
	,[KgJul]
	,[KgAug]
	,[KgSep]
	,[KgOkt]
	,[KgNov]
	,[KgDec])
) AS KG

UNION ALL

SELECT
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,0 AS [DB]
	,0 AS [KG]
	,[OMS]
	,0 AS [STK]
	,0 AS [DB kaffe]
	,0 AS [DB non-kaffe]
	,SUBSTRING([Måned],4,3) AS [MånedKort]
FROM (
SELECT 
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[OmsJan]
	,[OmsFeb]
	,[OmsMar]
	,[OmsApr]
	,[OmsMaj]
	,[OmsJun]
	,[OmsJul]
	,[OmsAug]
	,[OmsSep]
	,[OmsOkt]
	,[OmsNov]
	,[OmsDec]
FROM [Salgsbudget2017_Salgsbudget 2018$]) AS Master
UNPIVOT
(OMS FOR Måned IN
	([OmsJan]
	,[OmsFeb]
	,[OmsMar]
	,[OmsApr]
	,[OmsMaj]
	,[OmsJun]
	,[OmsJul]
	,[OmsAug]
	,[OmsSep]
	,[OmsOkt]
	,[OmsNov]
	,[OmsDec])
) AS OMS

UNION ALL

SELECT
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,0 AS [DB]
	,0 AS [KG]
	,0 AS [OMS]
	,[STK]
	,0 AS [DB kaffe]
	,0 AS [DB non-kaffe]
	,SUBSTRING([Måned],4,3) AS [MånedKort]
FROM (
SELECT 
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[StkJan]
	,[StkFeb]
	,[StkMar]
	,[StkApr]
	,[StkMaj]
	,[StkJun]
	,[StkJul]
	,[StkAug]
	,[StkSep]
	,[StkOkt]
	,[StkNov]
	,[StkDec]
FROM [Salgsbudget2017_Salgsbudget 2018$]) AS Master
UNPIVOT
(STK FOR Måned IN
	([StkJan]
	,[StkFeb]
	,[StkMar]
	,[StkApr]
	,[StkMaj]
	,[StkJun]
	,[StkJul]
	,[StkAug]
	,[StkSep]
	,[StkOkt]
	,[StkNov]
	,[StkDec])
) AS STK

UNION ALL

SELECT
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,0 AS [DB]
	,0 AS [KG]
	,0 AS [OMS]
	,0 AS [STK]
	,[DB kaffe]
	,0 AS [DB non-kaffe]
	,SUBSTRING([Måned],3,3) AS [MånedKort]
FROM (
SELECT 
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[DBJan Kaffe]
	,[DBFeb Kaffe]
	,[DBMar Kaffe]
	,[DBApr Kaffe]
	,[DBMaj Kaffe]
	,[DBJun Kaffe]
	,[DBJul Kaffe]
	,[DBAug Kaffe]
	,[DBSep Kaffe]
	,[DBOkt Kaffe]
	,[DBNov Kaffe]
	,[DBDec Kaffe]
FROM [Salgsbudget2017_Salgsbudget 2018$]) AS Master
UNPIVOT
([DB kaffe] FOR Måned IN
	([DBJan Kaffe]
	,[DBFeb Kaffe]
	,[DBMar Kaffe]
	,[DBApr Kaffe]
	,[DBMaj Kaffe]
	,[DBJun Kaffe]
	,[DBJul Kaffe]
	,[DBAug Kaffe]
	,[DBSep Kaffe]
	,[DBOkt Kaffe]
	,[DBNov Kaffe]
	,[DBDec Kaffe])
) AS DBKAF

UNION ALL

SELECT
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,0 AS [DB]
	,0 AS [KG]
	,0 AS [OMS]
	,0 AS [STK]
	,0 AS [DB kaffe]
	,[DB non-kaffe]
	,SUBSTRING([Måned],3,3) AS [MånedKort]
FROM (
SELECT 
	[Afdeling]
	,[Afdeling KGS]
	,[Sælgerkode code]
	,[Debitor Hash]
	,[Varenr]
	,[DBJan non-kaffe]
	,[DBFeb non-kaffe]
	,[DBMar non-kaffe]
	,[DBApr non-kaffe]
	,[DBMaj non-kaffe]
	,[DBJun non-kaffe]
	,[DBJul non-kaffe]
	,[DBAug non-kaffe]
	,[DBSep non-kaffe]
	,[DBOkt non-kaffe]
	,[DBNov non-kaffe]
	,[DBDec non-kaffe]
FROM [Salgsbudget2017_Salgsbudget 2018$]) AS Master
UNPIVOT
([DB non-kaffe] FOR Måned IN
	([DBJan non-kaffe]
	,[DBFeb non-kaffe]
	,[DBMar non-kaffe]
	,[DBApr non-kaffe]
	,[DBMaj non-kaffe]
	,[DBJun non-kaffe]
	,[DBJul non-kaffe]
	,[DBAug non-kaffe]
	,[DBSep non-kaffe]
	,[DBOkt non-kaffe]
	,[DBNov non-kaffe]
	,[DBDec non-kaffe])
) AS DBNONKAF
) AS Bud
ON Deb.[Debitor Hash] = Bud.[Debitor Hash]
