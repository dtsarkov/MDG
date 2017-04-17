IF OBJECT_ID('GDW20.v_Kaizen_EntityDefinitions', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_EntityDefinitions;   
GO

CREATE VIEW GDW20.v_Kaizen_EntityDefinitions AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 COALESCE(pkg.TPos+1,1)*10000 
		+COALESCE(d.TPos+1,1)*1000
		+do.Sequence					AS "table.id"
		,pkg.package_id
		,pkg.parent_id
		,o.Name							as TableCode
		,coalesce(o.Alias,o.Name)		as TableName
		,o.Note							as "Note.Formatted"
		,o.Status
		
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Logical Data Model%'
and		(o.stereotype	= 'table'
		or	(o.stereotype = 'view' and exists (
				select * from t_attribute a	
				where a.object_id = o.object_id		
			))
		)	
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')
