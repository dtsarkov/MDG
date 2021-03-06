IF OBJECT_ID('GDW20.v_Kaizen_ColumnDefinitions', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_ColumnDefinitions;   
GO

CREATE VIEW GDW20.v_Kaizen_ColumnDefinitions AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 do.sequence*10000				
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
										AS "COLUMN.ID"
		,pkg.package_id
		,pkg.parent_id 
		,'<b><font color="navy">'
		+o.Name
		+'</b></font>'					AS "ColumnCode.Formatted"
		,NULL							AS ColumnName
		,NULL							AS ColumnType
		,NULL							AS ColumnDefault
		,NULL							AS ColumnNullFlag
		,NULL							AS ColumnCompression
		,convert(varchar,o.Note)		AS "Notes.Formatted" 
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		o.stereotype	= 'table'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

UNION ALL

SELECT	 do.sequence*10000+a.Pos+1000	
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
										AS "COLUMN.ID"
		,pkg.package_id
		,pkg.parent_id 
		,'-    '+a.Name					AS "ColumnCode.Formatted"
		,a.Style						AS ColumnName
		,a.Type							
		+CASE WHEN a.Length <> 0 
			  THEN '('+convert(varchar,a.Length)+')'
			  WHEN a.Precision <> 0
			  THEN '('+convert(varchar,a.Precision)
		          +','+convert(varchar,a.Scale)+')'
		      ELSE ''
		 END							AS ColumnType
		,a.[Default]					AS ColumnDefault
		,CASE WHEN a.AllowDuplicates = 1
			  THEN 'N'
			  ELSE 'Y'
		 END							AS ColumnNullFlag
		,ta.Value						AS ColumnCompression
		,convert(varchar,a.Notes)		AS "Notes.Formatted" 
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id
JOIN	t_attribute			a	ON a.object_id		= o.object_id
LEFT JOIN t_attributetag	ta	ON ta.ElementId		= a.id and ta.property = 'Compress'

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		o.stereotype	= 'table'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

UNION ALL

SELECT	 do.sequence*10000+1000
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
		+p.ancestor_rank*100
										AS "COLUMN.ID"
		,pkg.package_id
		,pkg.parent_id 
		,'<b><i><font color="teal">::'
		+p.ancestor_name
		+'</i></b></font>'				AS "ColumnCode.Formatted"
		,NULL							AS ColumnName
		,NULL							AS ColumnType
		,NULL							AS ColumnDefault
		,NULL							AS ColumnNullFlag
		,NULL							AS ColumnCompression
		,NULL							AS "Notes.Formatted" 

FROM	t_diagram				d	
JOIN	t_package				pkg	ON pkg.package_id		= d.package_id
JOIN	t_diagramobjects		do	ON d.diagram_id			= do.diagram_id
JOIN	t_object				o	ON o.object_id			= do.object_id
JOIN	GDW20.v_AncestorTable	p	ON p.object_id			= do.Object_ID

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		o.stereotype	= 'table'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')
and		do.ObjectStyle like '%AttInh=1%'

UNION ALL

SELECT	 do.sequence*10000+1000
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
		+p.ancestor_rank*100
		+a.Pos+1
										AS "COLUMN.ID"
		,pkg.package_id
		,pkg.parent_id 
		,'-    <i>'+a.Name+'</i>'		AS "ColumnCode.Formatted"
		,a.Style						AS ColumnName
		,a.Type							
		+CASE WHEN a.Length <> 0 
			  THEN '('+convert(varchar,a.Length)+')'
			  WHEN a.Precision <> 0
			  THEN '('+convert(varchar,a.Precision)
		          +','+convert(varchar,a.Scale)+')'
		      ELSE ''
		 END							AS ColumnType
		,a.[Default]					AS ColumnDefault
		,CASE WHEN a.AllowDuplicates = 1
			  THEN 'N'
			  ELSE 'Y'
		 END							AS ColumnNullFlag
		,ta.Value						AS ColumnCompression
		,convert(varchar,a.Notes)		AS "Notes.Formatted" 

FROM	t_diagram				d	
JOIN	t_package				pkg	ON pkg.package_id		= d.package_id
JOIN	t_diagramobjects		do	ON d.diagram_id			= do.diagram_id
JOIN	t_object				o	ON o.object_id			= do.object_id
JOIN	GDW20.v_AncestorTable	p	ON p.object_id			= do.Object_ID
JOIN	t_attribute				a	ON a.object_id			= p.ancestor_id	and (
										(a.scope = 'Public'		and not do.ObjectStyle like '%AttPub=0%')
									OR	(a.scope = 'Protected'	and not do.ObjectStyle like '%AttPro=0%')
									OR	(a.scope = 'Private'	and not do.ObjectStyle like '%AttPri=0%')
									OR	(a.scope = 'Package'	and not do.ObjectStyle like '%AttPkg=0%')
									)
LEFT JOIN t_attributetag	ta	ON ta.ElementId		= a.id and ta.property = 'Compress'

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		o.stereotype	= 'table'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')
and		do.ObjectStyle like '%AttInh=1%'


UNION ALL

-- Indexes
-- ------------------------------------------------------------------------------------------------------
SELECT	 do.sequence*10000+2000
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
										AS "COLUMN.ID"
		,pkg.package_id
		,pkg.parent_id 
		,'<b><font color="darkgrey">'
		+idx.IndexName
		+'</b></font>'					AS "ColumnCode.Formatted"
		,NULL							AS ColumnName
		,idx.IndexType					AS ColumnType
		,NULL							AS ColumnDefault
		,NULL							AS ColumnNullFlag
		,idx.Columns					AS ColumnCompression
		,convert(varchar,o.Note)		AS "Notes.Formatted" 
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object				o	ON o.object_id		= do.object_id
JOIN	GDW20.v_indexies_flat	idx	ON idx.object_id		= do.object_id

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		o.stereotype	= 'table'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

UNION ALL

-- Partitions
-- ------------------------------------------------------------------------------------------------------
SELECT	 do.sequence*10000+3000
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
										AS "COLUMN.ID"
		,pkg.package_id
		,pkg.parent_id 
		,'<b><font color="darkgrey">'
		+idx.PartitionName
		+'</b></font>'					AS "ColumnCode.Formatted"
		,NULL							AS ColumnName
		,'PARTITION'					AS ColumnType
		,NULL							AS ColumnDefault
		,NULL							AS ColumnNullFlag
		,idx.PartitionCode				AS ColumnCompression
		,convert(varchar,o.Note)		AS "Notes.Formatted" 
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id
JOIN	GDW20.v_partitions	idx	ON idx.object_id		= do.object_id

WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		o.stereotype	= 'table'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

GO

SELECT * FROM GDW20.v_Kaizen_ColumnDefinitions
WHERE	package_id in (
			select package_id from t_package where ea_guid = '{DE899E59-0C3A-4944-9738-B8C9438445AE}'
		)
order by [COLUMN.ID]		

