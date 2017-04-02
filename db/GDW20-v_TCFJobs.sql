
IF OBJECT_ID('GDW20.v_TCFJobs', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_TCFJobs;   
GO

CREATE VIEW GDW20.v_TCFJobs AS

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT	 job.object_id		
		,job.package_id		
		,job.Name			as Name
		,job.Alias			as Alias
		,job.Note			as "Note.Formatted"
		,job.Status			as Status
		
		,ptrn.Value			as "TCF::Pattern"
		,rqmt.Value			as "TCF::RQM Type"		
		
		,viw.ViewName		as Output_ViewName
		,viw.DatabaseName	as Output_DatabaseName
		
		,tbl.TableName		as Target_TableName
		,tbl.DatabaseName	as Target_DatabaseName
		,tbl.Type			as Target_Type
		,tbl.Area			as Target_Areal

FROM		t_object			job
-- TCF Job Tagged values
LEFT JOIN	t_objectproperties	ptrn	ON ptrn.object_id		= job.object_id		AND ptrn.property	= 'TCF::Pattern'
LEFT JOIN	t_objectproperties	rqmt	ON rqmt.object_id		= job.object_id		AND rqmt.property	= 'TCF::RQM Type'

-- Output View
JOIN		t_connector			cnc1	ON cnc1.start_object_id	= job.object_id
JOIN		GDW20.v_views		viw		ON viw.object_id		= cnc1.end_object_id
-- Target Table
JOIN		t_connector			cnc2	ON cnc2.start_object_id	= viw.object_id
JOIN		GDW20.v_tables		tbl		ON tbl.object_id		= cnc2.end_object_id


WHERE	job.stereotype	= 'TCF Job'
