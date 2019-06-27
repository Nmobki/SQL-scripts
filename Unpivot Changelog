CREATE VIEW [dbo].[ProdBomChangeLogUnpivot]
AS
SELECT
	[DW_Account]
	,[Created date]
	,[Entry No.]
	,[Activity]
	,[Recipe]
	,CAST([Component] AS VARCHAR(20)) AS [Component]
	,SUM([QTY_PER]) AS [QTY_PER]
	,DENSE_RANK() OVER (PARTITION BY [Created date], [Recipe] ORDER BY [Entry No.] DESC) AS [Rank]
FROM (
SELECT
	[DW_Account]
	,[Created date]
	,[Entry No.]
	,[Activity]
	,CASE
		WHEN [ZONE] = 1 THEN CAST('10401' + RIGHT([Customer code],3) AS VARCHAR(20))
		WHEN [ZONE] = 2 THEN CAST('10502' + RIGHT([Customer code],3) AS VARCHAR(20))
		ELSE NULL
	END AS [Recipe]
	,[Type comp 01]
	,[Type comp 02]
	,[Type comp 03]
	,[Type comp 04]
	,[Type comp 05]
	,[Type comp 06]
	,[Type comp 07]
	,[Type comp 08]
	,[Type comp 09]
	,[Type comp 10]
	,[Type comp 11]
	,[Type comp 12]
	,[Type comp 13]
	,[Type comp 14]
	,[Part comp 01 qty. per]
	,[Part comp 02 qty. per]
	,[Part comp 03 qty. per]
	,[Part comp 04 qty. per]
	,[Part comp 05 qty. per]
	,[Part comp 06 qty. per]
	,[Part comp 07 qty. per]
	,[Part comp 08 qty. per]
	,[Part comp 09 qty. per]
	,[Part comp 10 qty. per]
	,[Part comp 11 qty. per]
	,[Part comp 12 qty. per]
	,[Part comp 13 qty. per]
	,[Part comp 14 qty. per]
FROM [NAV_dbo_PROBAT Prod. BOM Change Log]
) AS PCL

UNPIVOT (
	[Component]
	FOR [GreenCoffee] IN ([Type comp 01],[Type comp 02],[Type comp 03],[Type comp 04],[Type comp 05],[Type comp 06],[Type comp 07],[Type comp 08],[Type comp 09],[Type comp 10],[Type comp 11],[Type comp 12],[Type comp 13],[Type comp 14])
	) AS COM

UNPIVOT (
	[QTY_PER]
	FOR [QTY] IN ([Part comp 01 qty. per],[Part comp 02 qty. per],[Part comp 03 qty. per],[Part comp 04 qty. per],[Part comp 05 qty. per],[Part comp 06 qty. per],[Part comp 07 qty. per],[Part comp 08 qty. per],[Part comp 09 qty. per],[Part comp 10 qty. per],[Part comp 11 qty. per],[Part comp 12 qty. per],[Part comp 13 qty. per],[Part comp 14 qty. per])
	) AS QTY

WHERE RIGHT([GreenCoffee],2) = SUBSTRING([QTY],11,2)
AND [Component] <> ''


GROUP BY
	[DW_Account]
	,[Created date]
	,[Entry No.]
	,[Activity]
	,[Recipe]
	,[Component]
