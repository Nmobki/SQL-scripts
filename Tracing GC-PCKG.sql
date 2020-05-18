USE [BKI_IMP_EXP]

GO

DECLARE @CONTRACT VARCHAR(20)
DECLARE @DELIVERY VARCHAR(20)

SET @CONTRACT = '13-376'
SET @DELIVERY = '1'

;

WITH [CTE_TRACE] AS (
SELECT DISTINCT
	LR.[S_CONTRACT_NO] AS [CONTRACT NO]
	,LR.[S_DELIVERY_NAME] AS [DELIVERY]
	,LR.[S_TYPE_CELL] AS [CUSTOMER CODE]
	,LR.[PRODUCTION_ORDER_ID] AS [ROASTING ORDER ID]
	,LG.[PRODUCTION_ORDER_ID] AS [GRINDING ORDER ID]
	,PB.[PRODUCTION_ORDER_ID] AS [PB ORDER ID]
	,PG.[PRODUCTION_ORDER_ID] AS [PG ORDER ID]
FROM [dbo].[PRO_EXP_ORDER_LOAD_R] AS LR
LEFT JOIN [dbo].[PRO_EXP_ORDER_UNLOAD_R] AS ULR
	ON LR.[PRODUCT_ID] = ULR.[S_PRODUCT_ID]
LEFT JOIN [dbo].[PRO_EXP_ORDER_SEND_PB] AS PB
	ON ULR.[S_PRODUCT_ID] = PB.[S_PRODUCT_ID]
LEFT JOIN [dbo].[PRO_EXP_ORDER_LOAD_G] AS LG
	ON ULR.[S_PRODUCT_ID] = LG.[S_PRODUCT_ID]
LEFT JOIN [dbo].[PRO_EXP_ORDER_UNLOAD_G] AS ULG
	ON LG.[PRODUCT_ID] = ULG.[S_PRODUCT_ID]
LEFT JOIN [dbo].[PRO_EXP_ORDER_SEND_PG] AS PG
	ON ULG.[S_PRODUCT_ID] = PG.[S_PRODUCT_ID]
WHERE LR.[S_CONTRACT_NO] = @CONTRACT
	AND LR.[S_DELIVERY_NAME] = @DELIVERY
)
, [CTE_ROAST] AS (
SELECT DISTINCT
	[ROASTING ORDER ID]
FROM [CTE_TRACE]
)
, [CTE_GRIND] AS (
SELECT DISTINCT
	[GRINDING ORDER ID]
FROM [CTE_TRACE]
)
, [CTE_PB] AS (
SELECT DISTINCT
	[PB ORDER ID]
FROM [CTE_TRACE]
)
, [CTE_PG] AS (
SELECT DISTINCT
	[PG ORDER ID]
FROM [CTE_TRACE]
)
, [CTE_LR] AS (
SELECT
	'ROAST' AS [PROCES]
	,DATEADD(D, DATEDIFF(D, 0, [LR].[RECORDING_DATE] ), 0)  AS [DATE]
	,[LR].[CUSTOMER_CODE]
	,[LR].[DESTINATION] AS [MACHINE]
	,[LR].[PRODUCTION_ORDER_ID]
	,[LR].[ORDER_NAME]
	,SUM(CAST([LR].[WEIGHT] AS BIGINT)) AS [GC WEIGHT]
	,SUM(CAST(CASE
		WHEN [LR].[S_CONTRACT_NO] = @CONTRACT AND [LR].[S_DELIVERY_NAME] = @DELIVERY
			THEN [LR].[WEIGHT]
		ELSE 0
	END AS BIGINT)) AS [CONTRACT KG]
FROM [dbo].[PRO_EXP_ORDER_LOAD_R] AS [LR]
INNER JOIN [CTE_ROAST]
	ON [LR].[PRODUCTION_ORDER_ID] = [CTE_ROAST].[ROASTING ORDER ID]
GROUP BY
	DATEADD(D, DATEDIFF(D, 0, LR.[RECORDING_DATE] ), 0)
	,[LR].[CUSTOMER_CODE]
	,[LR].[DESTINATION]
	,[LR].[PRODUCTION_ORDER_ID]
	,[LR].[ORDER_NAME]
)
SELECT
	[CTE_LR].*
	,[ULR].[WEIGHT]
FROM [CTE_LR]
LEFT JOIN (
SELECT
	[ULR].[PRODUCTION_ORDER_ID]
	,SUM(CAST([ULR].[WEIGHT] AS BIGINT)) AS [WEIGHT]
FROM [dbo].[PRO_EXP_ORDER_UNLOAD_R] AS [ULR]
INNER JOIN [CTE_ROAST]
	ON [ULR].[PRODUCTION_ORDER_ID] = [CTE_ROAST].[ROASTING ORDER ID]
GROUP BY
[ULR].[PRODUCTION_ORDER_ID]
) AS [ULR]
	ON [CTE_LR].[PRODUCTION_ORDER_ID] = [ULR].[PRODUCTION_ORDER_ID]

UNION ALL

SELECT
	'GRINDER'
	,DATEADD(D, DATEDIFF(D, 0, [ULG].[RECORDING_DATE]), 0) AS [DATE]
	,[ULG].[D_CUSTOMER_CODE] AS [CUSTOMER_CODE]
	,'M' + [ULG].[SOURCE_NAME] AS [MACHINE]
	,[ULG].[PRODUCTION_ORDER_ID]
	,[ULG].[ORDER_NAME]
	,NULL 
	,NULL
	,SUM(CAST([ULG].[WEIGHT] AS BIGINT)) AS [WEIGHT]
FROM [dbo].[PRO_EXP_ORDER_UNLOAD_G] AS [ULG]
INNER JOIN [CTE_GRIND]
	ON [ULG].[PRODUCTION_ORDER_ID] = [CTE_GRIND].[GRINDING ORDER ID]
GROUP BY
	DATEADD(D, DATEDIFF(D, 0, [ULG].[RECORDING_DATE]), 0)
	,[ULG].[D_CUSTOMER_CODE]
	,[ULG].[SOURCE_NAME]
	,[ULG].[PRODUCTION_ORDER_ID]
	,[ULG].[ORDER_NAME]

UNION ALL

SELECT
	'WHOLE BEANS P'
	,DATEADD(D, DATEDIFF(D, 0, [PB].[RECORDING_DATE]), 0) AS [DATE]
	,[PB].[CUSTOMER_CODE] AS [CUSTOMER_CODE]
	,[PB].[DESTINATION] AS [MACHINE]
	,NULL
	,[PB].[ORDER_NAME]
	,NULL 
	,NULL
	,SUM(CAST([PB].[WEIGHT] AS BIGINT)) AS [WEIGHT]
FROM [dbo].[PRO_EXP_ORDER_SEND_PB] AS [PB]
INNER JOIN [CTE_PB]
	ON [PB].[PRODUCTION_ORDER_ID] = [CTE_PB].[PB ORDER ID]
GROUP BY
	DATEADD(D, DATEDIFF(D, 0, [PB].[RECORDING_DATE]), 0)
	,[PB].[CUSTOMER_CODE]
	,[PB].[DESTINATION]
	,[PB].[ORDER_NAME]

UNION ALL

SELECT
	'GROUND P'
	,DATEADD(D, DATEDIFF(D, 0, [PG].[RECORDING_DATE]), 0) AS [DATE]
	,[PG].[CUSTOMER_CODE] AS [CUSTOMER_CODE]
	,[PG].[DESTINATION] AS [MACHINE]
	,NULL
	,[PG].[ORDER_NAME]
	,NULL 
	,NULL
	,SUM(CAST([PG].[WEIGHT] AS BIGINT)) AS [WEIGHT]
FROM [dbo].[PRO_EXP_ORDER_SEND_PG] AS [PG]
INNER JOIN [CTE_PG]
	ON [PG].[PRODUCTION_ORDER_ID] = [CTE_PG].[PG ORDER ID]
GROUP BY
	DATEADD(D, DATEDIFF(D, 0, [PG].[RECORDING_DATE]), 0)
	,[PG].[CUSTOMER_CODE]
	,[PG].[DESTINATION]
	,[PG].[ORDER_NAME]