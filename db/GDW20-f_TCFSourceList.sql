IF OBJECT_ID (N'GDW20.SourceList', N'FN') IS NOT NULL  
    DROP FUNCTION GDW20.SourceList;  
GO  

CREATE FUNCTION GDW20.SourceList (
   @STRM_PACKAGE_ID	AS INTEGER
  ,@TABL_OBJECT_ID	AS INTEGER
) RETURNS VARCHAR(4000)
AS

BEGIN
-- ------------------------------------------------------------------------------------------------------------------
--
-- ------------------------------------------------------------------------------------------------------------------
DECLARE @LIST AS VARCHAR(4000)

	SELECT @LIST= sjob.Name
	FROM	t_object		sjob
	
	JOIN	t_connector		cnct
	ON		cnct.Start_Object_ID	=	sjob.object_id
	AND		cnct.End_Object_ID		=	@TABL_OBJECT_ID
	WHERE	sjob.package_id = @STRM_PACKAGE_ID
	AND		sjob.stereotype = 'TCF Job'
	;
	
	--SELECT * FROM t_connector
	RETURN(@LIST);
END 
GO

SELECT GDW20.SourceList(65,12743)
--[65] - [12744]
/*
declare @#PACKAGEID# as int
select @#PACKAGEID# = package_id from t_package where name = 'RBS Planning'

SELECT	 dstr.Sequence
		,strm."TCF::Stream ID"				AS "TCFStreamKey"
		,cnct.Notes							AS "Source.Formatted"
		,tbl.TableName
		,tbl.DatabaseName
		,CASE WHEN strm.status in ('Proposed', 'New') 
			  THEN 'New'
			  ELSE 'Existing'
		 END								AS "Status"
		,tbl.Type+' - '+job."TCF::Pattern"	AS "Pattern"
		,GDW20.SourceList(strm.package_id, tbl.object_id)
		
FROM		t_diagram			d	

JOIN		t_diagramobjects	dstr	ON dstr.diagram_id		= d.diagram_id	
JOIN		GDW20.v_TCFStreams	strm	ON strm.object_id		= dstr.object_id	
JOIN		t_connector			cnct	ON cnct.Start_Object_ID = strm.object_id
JOIN		GDW20.v_tables		tbl		ON tbl.object_id		= cnct.End_Object_ID
JOIN		GDW20.v_TCFJobs		job		ON job.package_id		= strm.package_id		AND job.Target_TableName = tbl.TableName

WHERE	d.package_id	= @#PACKAGEID#
AND		d.stereotype	= 'Context Diagram'
AND		(	strm.status	IN ('Proposed','New') 
	OR		tbl.status	IN ('Proposed', 'Modified','New')
	)

ORDER BY dstr.Sequence
;
*/