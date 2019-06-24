WITH BOMCTE AS (
    SELECT
	I.[No.] AS [Top level item]
	,0 AS [Level]
	,I.[Production BOM No.]
	,BOM.[Version Code]
	,BOM.[No.] AS [Component]
	,BOM.[Version starting date] AS [Start date]
	,BOM.[Version ending date] AS [End date]
	,BOM.[Quantity per]
	,BOM.[Scrap %] AS [Scrap pct]
	,BOM.[Quantity per] * (1 + BOM.[Scrap %] / 100) AS [Component qty per incl scrap]
	,BOM.[Unit of Measure Code] AS [Component unit of measure]
	,BOM.[Quantity per] * (1 + BOM.[Scrap %] / 100) AS [Component qty per top level item incl scrap]
	,BOM.[DW_Account]
    FROM [Item_V] AS I
    INNER JOIN [Production BOM Line_V] AS BOM
	ON BOM.[Production BOM No.] = I.[Production BOM No.]
	AND BOM.[DW_Account] = I.[DW_Account]
    WHERE I.[Production BOM No.] <> ''
	AND BOM.[Version starting date] IS NOT NULL

    UNION ALL

    SELECT
	BOMCTE.[Top level item]
	,BOMCTE.[Level] + 1 AS [Level]
	,I.[Production BOM No.]
	,BOM.[Version Code]
	,BOM.[No.] AS [Component]
	,BOM.[Version starting date] AS [Start date]
	,BOM.[Version ending date] AS [End date]
	,BOM.[Quantity per]
	,BOM.[Scrap %] AS [Scrap pct]
	,BOM.[Quantity per] * (1 + BOM.[Scrap %] / 100) AS [Component qty per incl scrap]
	,BOM.[Unit of Measure Code] AS [Component unit of measure]
	,( BOMCTE.[Component qty per top level item incl scrap] * BOM.[Quantity per] ) * ( 1 + BOM.[Scrap %] / 100) AS [Component qty per top level item incl scrap]
	,BOM.[DW_Account]
    FROM BOMCTE
    INNER JOIN [Item_V] AS I
	ON BOMCTE.[Component] = I.[No.]
	AND BOMCTE.[DW_Account] = I.[DW_Account]
    INNER JOIN [Production BOM Line_V] AS BOM
	ON BOM.[Production BOM No.] = I.[Production BOM No.]
	AND BOM.[DW_Account] = I.[DW_Account]
	AND BOM.[Version starting date] <= BOMCTE.[End date]
	AND BOM.[Version ending date]  >= BOMCTE.[Start date]
    WHERE BOM.[Version starting date] IS NOT NULL
)

SELECT
	[DW_Account]
	,[Top level item]
	,[Level]
	,[Production BOM No.]
	,[Version Code]
	,[Start date]
	,[End date]
	,[Component]
	,[Component unit of measure]
	,[Quantity per] AS [Component qty per]
	,[Scrap pct]
	,[Component qty per incl scrap]
	,[Component qty per top level item incl scrap]
	,'Table insert' AS [DW_SourceCode]
FROM BOMCTE

OPTION (MAXRECURSION 0)
