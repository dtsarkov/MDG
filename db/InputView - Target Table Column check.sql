SELECT *
FROM (
	SELECT	 trgt_tabl.*
			,attr.Name			AS ColumnName
			,attr.Type			AS ColumnType
	FROM GDW20.v_TCF_TargetTable trgt_tabl
	JOIN	t_attribute			attr	ON attr.object_id	= trgt_tabl.TableID
	
	UNION ALL
	SELECT	 trgt_tabl.*
			,attr.Name			AS ColumnName
			,attr.Type			AS ColumnType
	FROM GDW20.v_TCF_TargetTable trgt_tabl
	JOIN GDW20.v_AncestorTable	 ancs_tabl		ON ancs_tabl.object_id = trgt_tabl.TableID
	JOIN	t_attribute			attr			ON attr.object_id	= ancs_tabl.ancestor_id

) TBL

		
FULL JOIN (
	SELECT	 inpt_view.*
			,attr.Name			AS ColumnName
			,attr.Type			AS ColumnType
	FROM (
		SELECT   job0.*
				,oviw.Name			as ViewName
				,oviw.Object_ID		as ViewID
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
		JOIN t_connector		trg1	ON trg1.End_Object_ID	= job0.JobID			AND trg1.Connector_Type = 'Dependency'
		JOIN t_object			oviw	ON oviw.Object_ID		= trg1.Start_Object_ID	AND oviw.Stereotype = 'view'
	) inpt_view
	JOIN	t_attribute			attr	ON attr.object_id	= inpt_view.ViewID
) VIW
ON		VIW.JobID		= TBL.JobID
AND		VIW.ColumnName	= TBL.ColumnName

WHERE --(TBL.TableName IS NULL or VIW.ViewName IS NULL)

COALESCE(TBL.StreamID,VIW.StreamID) in (
		select  pkg.Package_ID
		from 	 t_object						obj
				,t_objectproperties             tag
				,t_package						pkg
		where 	obj.Object_ID	= tag.Object_ID
		and		pkg.ea_guid		= obj.ea_guid
		and		tag.Property	= 'TCF::Stream ID'
		and		obj.Stereotype	= 'TCF Stream'
		and		tag.Value = '1389'
	)

order by coalesce(TBL.JobName,VIW.JobName), TBL.TableName	