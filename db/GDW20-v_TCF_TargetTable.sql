IF OBJECT_ID('GDW20.v_TCF_TargetTable', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_TCF_TargetTable;   
GO

CREATE VIEW GDW20.v_TCF_TargetTable AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
	SELECT   job0.JobID
			,job0.JobName
			,job0.StreamID
			,tabl.Name		as TableName
			,tabl.Object_ID	as TableID
	FROM (
		SELECT	 tjob.Name			AS JobName
				,tjob.Object_ID		AS JobID
				,strp.Package_ID	AS StreamID
		FROM	t_object			tjob	
		JOIN	t_package			strp	ON strp.Package_ID	= tjob.Package_ID
		JOIN	t_object			stro	ON stro.ea_guid		= strp.ea_guid

		WHERE	tjob.stereotype	= 'TCF Job'
		AND		stro.Stereotype = 'TCF Stream'
	) job0
	JOIN t_connector		trg1	ON trg1.Start_Object_ID = job0.JobID			AND trg1.Connector_Type = 'Dependency'
	JOIN t_object			oviw	ON oviw.Object_ID		= trg1.End_Object_ID	AND oviw.Stereotype = 'view'
	JOIN t_connector		trg2	ON trg2.Start_Object_ID = oviw.Object_ID		AND trg2.Connector_Type = 'Dependency'
	JOIN t_object			tabl	ON tabl.Object_ID		= trg2.End_Object_ID	AND tabl.Stereotype = 'table'
		
GO

SELECT * FROM GDW20.v_TCF_TargetTable 