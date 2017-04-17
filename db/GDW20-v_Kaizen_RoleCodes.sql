IF OBJECT_ID('GDW20.v_Kaizen_RoleCodes', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_RoleCodes;   
GO

CREATE VIEW GDW20.v_Kaizen_RoleCodes AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 o.object_id				as "role.id"
		,o.Name						as RoleCode
		,coalesce(o.Alias,o.Name)	as RoleName
		,o.Note						as "Note.Formatted"
		,o.Status
		,c.End_Object_ID			
		,t.name						as TableCode
		,t.alias					as TableName
		,pkg.package_id
		,pkg.parent_id 
		
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id		= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id			= do.diagram_id
JOIN	t_object			o	ON o.object_id			= do.object_id
LEFT JOIN t_connector		c	ON c.start_object_id	= do.object_id
LEFT JOIN t_object			t	ON t.object_id			= c.end_object_id

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Logical Data Model%'
and		o.stereotype	= 'Role'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')
;