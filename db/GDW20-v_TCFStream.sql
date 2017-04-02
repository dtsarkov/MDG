IF OBJECT_ID('GDW20.v_TCFStreams', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_TCFStreams;   
GO

CREATE VIEW GDW20.v_TCFStreams AS

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 strm.object_id		
		,pckg.package_id
		,strm.Name			as Name
		,strm.Alias			as Alias
		,strm.Note			as "Note.Formatted"
		,strm.Status
		
		,skey.Value			as "TCF::Stream ID"
		
FROM		t_object			strm
JOIN		t_package			pckg	ON pckg.ea_guid		= strm.ea_guid
LEFT JOIN	t_objectproperties	skey	ON skey.object_id	= strm.object_id	AND skey.property	= 'TCF::Stream ID'

WHERE	strm.stereotype	= 'TCF Stream'
