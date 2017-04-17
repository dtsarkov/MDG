IF OBJECT_ID('GDW20.v_Kaizen_Requirements', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_Requirements;   
GO

CREATE VIEW GDW20.v_Kaizen_Requirements AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 COALESCE(pkg.TPos+1,1)*10000 
		+COALESCE(d.TPos+1,1)*1000
		+do.Sequence					AS "requirement.id"
		,pkg.package_id
		,pkg.parent_id 
		,o.Name						
		,o.Alias	
		,o.Note						as "Note.Formatted"
		,o.Stereotype	
		,o.Status
		
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id

WHERE	d.StyleEx		like '%Extended::Requirements%'
and		o.Object_Type	in ('Requirement')
and		not o.status	in ('Implemented','Descoped')
