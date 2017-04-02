
IF OBJECT_ID('GDW20.v_views', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_views;   
GO

CREATE VIEW GDW20.v_views AS

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 Q.*
		,o.Note						as "Note.Formatted"
		,o.Status
FROM(		
	SELECT	DISTINCT 
			 o.object_id				
			,o.package_id
			,o.Name						as ViewName
			,p.Name						as DatabaseName
			,COALESCE(o.Alias,o.Name)	as ViewLogicalName
			,CASE WHEN x.Description LIKE '%@STEREO;Name=Satellite%'	THEN 'Satellite'
				  WHEN x.Description LIKE '%@STEREO;Name=Link%'			THEN 'Link'
				  WHEN x.Description LIKE '%@STEREO;Name=Hub%'			THEN 'Hub'
				  WHEN x.Description LIKE '%@STEREO;Name=Reference%'	THEN 'Reference'
				  WHEN x.Description LIKE '%@STEREO;Name=Fact Table%'	THEN 'Fact'
				  WHEN po.Name		 LIKE '%INP%'						THEN 'Trasformation'
				  WHEN po.Name		 LIKE '%OUT%'						THEN 'Output'
																		ELSE 'View'
			 END						as Type
			,CASE WHEN po.Name LIKE '%RAW%' THEN 'RDV         '
				  WHEN po.Name LIKE '%BUS%' THEN 'BDV         '
				  WHEN po.Name LIKE '%SHR%' THEN 'BDV         '
				  WHEN po.Name LIKE '%BAL%' THEN 'BAL         '
				  WHEN po.Name LIKE '%REF%' THEN 'Reference   '
				  WHEN po.Name LIKE '%COX%' THEN 'Co-Existence'
				  WHEN po.Name LIKE '%EXP%' THEN 'Export      '
					 						ELSE '            '
			 END						as Area
			
			
	FROM		t_diagram			d	
	JOIN		t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
	JOIN		t_object			o	ON o.object_id		= do.object_id
	LEFT JOIN	t_xref				x	ON x.client			= o.ea_guid
	LEFT JOIN	t_package			p	ON p.package_id		= o.package_id 
	LEFT JOIN	t_object			po	ON po.ea_guid		= p.ea_guid AND po.stereotype = 'database'

	WHERE	o.stereotype	= 'view'
	and		o.abstract		= 0
) q
JOIN t_object	o	ON o.object_id = q.object_id


