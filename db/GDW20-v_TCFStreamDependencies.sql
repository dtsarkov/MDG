IF OBJECT_ID('GDW20.v_TCFStreamDependencies', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_TCFStreamDependencies;   
GO

CREATE VIEW GDW20.v_TCFStreamDependencies AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT strm.object_id
	  ,strm."TCF::Stream ID"
	  ,tag1.Value		AS "Polling Stream ID"
	  ,tag2.Value		AS "Polling Type"
	  ,tag3.Value		AS "Polling Interval"
	  ,tag4.Value		AS "Polling Retries"
	  ,tag5.Value		AS "Polling Offset"
	  ,tag6.Value		AS "Polling Days"
	  ,tag7.Value		AS "Polling Exit Code"
	  
FROM		GDW20.v_TCFStreams			strm
JOIN		t_object			polj	ON polj.package_id	= strm.package_id	AND	polj.stereotype = 'Poll Job'
LEFT JOIN	t_objectproperties	tag1	ON tag1.object_id	= polj.object_id	AND tag1.property	= 'AS::Polling Stream ID'
LEFT JOIN	t_objectproperties	tag2	ON tag2.object_id	= polj.object_id	AND tag2.property	= 'AS::Polling Type'
LEFT JOIN	t_objectproperties	tag3	ON tag3.object_id	= polj.object_id	AND tag3.property	= 'AS::Polling Interval'
LEFT JOIN	t_objectproperties	tag4	ON tag4.object_id	= polj.object_id	AND tag4.property	= 'AS::Polling Retries'
LEFT JOIN	t_objectproperties	tag5	ON tag5.object_id	= polj.object_id	AND tag5.property	= 'AS::Polling Offset'
LEFT JOIN	t_objectproperties	tag6	ON tag6.object_id	= polj.object_id	AND tag6.property	= 'AS::Polling Days'
LEFT JOIN	t_objectproperties	tag7	ON tag7.object_id	= polj.object_id	AND tag7.property	= 'AS::Polling Exit Code'
