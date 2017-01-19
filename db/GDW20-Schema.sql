IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'GDW20')
   EXEC sys.sp_executesql N'CREATE SCHEMA [GDW20] AUTHORIZATION [dbo]'
GO

IF OBJECT_ID('GDW20.v_indexies', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_indexies;   
GO

CREATE VIEW GDW20.v_indexies AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 OperationID
		,Object_ID
		,Pos
		,Name			as IndexName
		,Style			as IndexType
FROM t_operation
WHERE	stereotype = 'index'
and		style IN ('NUPI','UPI','NUSI','USI')

UNION ALL
SELECT	 OperationID
		,Object_ID
		,0				as Pos
		,Name			as IndexName
		,'UPI'			as IndexType
FROM t_operation	pk
WHERE	stereotype = 'PK'
and		not exists (
			SELECT * FROM t_operation idx
			WHERE	idx.style IN ('NUPI','UPI')
			and		idx.object_id = pk.object_id
		)	
GO

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
IF OBJECT_ID('GDW20.v_indexies_flat', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_indexies_flat;   
GO

CREATE VIEW GDW20.v_indexies_flat AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 idx.* 
		,clmn."Columns"
FROM GDW20.v_indexies		idx
JOIN (
	SELECT	 OperationID
			,MAX(CASE WHEN Pos =  0 THEN     Name ELSE '' END) 
			+MAX(CASE WHEN Pos =  1 THEN ','+Name ELSE '' END) 
			+MAX(CASE WHEN Pos =  2 THEN ','+Name ELSE '' END) 
			+MAX(CASE WHEN Pos =  3 THEN ','+Name ELSE '' END) 
			+MAX(CASE WHEN Pos =  4 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos =  5 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos =  6 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos =  7 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos =  8 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos =  9 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 10 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 11 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 12 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 13 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 14 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 15 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 16 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 17 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 18 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 19 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 20 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 21 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 22 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 23 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 24 THEN ','+Name ELSE '' END)
			+MAX(CASE WHEN Pos = 25 THEN ','+Name ELSE '' END)  AS "Columns"
	FROM t_operationparams
	GROUP BY OperationID
) clmn
ON		clmn.OperationID = idx.OperationID
GO


-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
IF OBJECT_ID('GDW20.v_partitions', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_partitions;   
GO

CREATE VIEW GDW20.v_partitions AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 o.object_id
		,o.OperationID
		,o.Name			AS PartitionName
		,o.Code			AS PartitionCode
		,o.Pos
--		,o.*
FROM t_operation	o
WHERE	stereotype	= 'check'
and		style		= 'PARTITION'

GO