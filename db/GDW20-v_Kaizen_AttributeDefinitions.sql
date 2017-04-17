IF OBJECT_ID('GDW20.v_Kaizen_AttributeDefinitions', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_AttributeDefinitions;   
GO

CREATE VIEW GDW20.v_Kaizen_AttributeDefinitions AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 do.sequence*1000+a.pos+1	
		+COALESCE(pkg.TPos+1,1)*10000 AS "column.id"
		,d.package_id
		,pkg.parent_id
		,'-    '+a.Style			AS "ColumnName.Formatted"
		,CASE WHEN a.IsOrdered = 1
			  THEN 'PK'
			  ELSE NULL 
		 END						AS ColumnFlags
		,coalesce('<b>'+ta.Value+':<b> ','')
		+convert(varchar(4000),a.Notes)	AS "Notes.Formatted" 

FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id		= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id
JOIN	t_attribute			a	ON a.object_id		= o.object_id
LEFT JOIN t_attributetag	ta	ON ta.ElementId		= a.id and ta.property = 'BGID'

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Logical Data Model%'
and		o.stereotype	in ('table','view')
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

UNION ALL 

SELECT	 do.sequence*1000
		+COALESCE(pkg.TPos+1,1)*10000
		+(rank() over(partition by o.object_id order by p.name))*100
		+a.pos+1	
									AS "column.id"
		,d.package_id
		,pkg.parent_id
		,'-    '+a.Style			AS "ColumnName.Formatted"
		,CASE WHEN a.IsOrdered = 1
			  THEN 'PK'
			  ELSE NULL 
		 END						AS ColumnFlags
		,coalesce('<b>'+ta.Value+':<b> ','')
		+convert(varchar(4000),a.Notes)	AS "Notes.Formatted" 

FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id		= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id			= do.diagram_id
JOIN	t_object			o	ON o.object_id			= do.object_id
JOIN	t_connector			c	ON c.start_object_id	= do.object_id		and c.connector_type = 'Generalization'
JOIN	t_object			p	ON p.object_id			= c.end_object_id	and	p.stereotype	 = 'table'
JOIN	t_attribute			a	ON a.object_id			= p.object_id		and (
									(a.scope = 'Public'		and not do.ObjectStyle like '%AttPub=0%')
								OR	(a.scope = 'Protected'	and not do.ObjectStyle like '%AttPro=0%')
								OR	(a.scope = 'Private'	and not do.ObjectStyle like '%AttPri=0%')
								OR	(a.scope = 'Package'	and not do.ObjectStyle like '%AttPkg=0%')
								)
LEFT JOIN t_attributetag	ta	ON ta.ElementId		= a.id and ta.property = 'BGID'

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Logical Data Model%'
and		o.stereotype	in ('table','view')
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')
and		do.ObjectStyle like '%AttInh=1%'

UNION ALL 

SELECT	 do.sequence*1000 			
		+COALESCE(pkg.TPos+1,1)*10000	AS "column.id"
		,d.package_id
		,pkg.parent_id
		,'<b><font color="navy">'
		+coalesce(o.Alias,o.Name)	
		+'</font></b>'				AS "ColumnName.Formatted"
		,NULL						AS ColumnFlags
		,NULL 						AS "Notes.Formatted" 
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

UNION ALL 

SELECT	do.sequence*1000
		+COALESCE(pkg.TPos+1,1)*10000
		+(rank() over(partition by o.object_id order by p.name))*100 			AS "column.id"
		,d.package_id
		,pkg.parent_id
		,'<b><i><font color="teal">::'
		+coalesce(p.Alias,p.Name)	
		+'</font></i></b>'				AS "ColumnName.Formatted"
		,NULL						AS ColumnFlags
		,NULL 						AS "Notes.Formatted" 
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id		= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id			= do.diagram_id
JOIN	t_object			o	ON o.object_id			= do.object_id
JOIN	t_connector			c	ON c.start_object_id	= do.object_id		and c.connector_type = 'Generalization'
JOIN	t_object			p	ON p.object_id			= c.end_object_id	and	p.stereotype	 = 'table'

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Logical Data Model%'
and		o.stereotype	in ('table','view')
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')
and		do.ObjectStyle like '%AttInh=1%'
;

