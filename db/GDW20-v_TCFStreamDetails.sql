IF OBJECT_ID('GDW20.v_TCFStreamDetails', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_TCFStreamDetails;   
GO

CREATE VIEW GDW20.v_TCFStreamDetails AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT	 strm.object_id		
		,strm.package_id
		,strm.Name
		,strm.Alias
		,strm."Note.Formatted"
		,strm.Status
		,strm."TCF::Stream ID"
		
		,tbdo.Value			as "TCF::Business Date Offset"
		,adow.Value			as "AS::days_of_week"
		,bteq.Name			as "BTEQ_Script_Name"
		,bteq.Note			as "BTEQ_Note.Formatted"
		
FROM GDW20.v_TCFStreams			strm
-- properties
LEFT JOIN	t_objectproperties	tbdo	ON tbdo.object_id	= strm.object_id	AND tbdo.property	= 'TCF::Business Date Offset'
LEFT JOIN	t_objectproperties	adow	ON adow.object_id	= strm.object_id	AND adow.property	= 'AS::days_of_week'

-- BTEQ Script
LEFT JOIN	(
	SELECT	 strt.package_id
			,bteq.Name
			,bteq.Note
	FROM t_object			strt		
	
	JOIN	t_connector			c1		
	ON c1.start_object_id	= strt.object_id	
	
	JOIN	t_object			bteq	
	ON	bteq.object_id		= c1.end_object_id	
	AND	bteq.stereotype		= 'sqlquery'
	
	WHERE strt.stereotype = 'StartStream'
) bteq									ON bteq.package_id		= strm.package_id


