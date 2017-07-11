/*
IF OBJECT_ID('GDW20.v_Kaizen_Macros', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_Macros;   
GO

CREATE VIEW GDW20.v_Kaizen_Macros AS
*/
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 do.sequence*10000				
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
										AS "COLUMN.ID"
		,o.Object_ID
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
and		o.stereotype	= 'Macro'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

UNION ALL

SELECT	 do.sequence*10000+a.Pos+1000	
		+COALESCE(pkg.TPos+1,1)*1000000+COALESCE(d.TPos+1,1)*100000	
										AS "COLUMN.ID"
		,o.Object_ID
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
and		o.stereotype	= 'Macro'
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')

order by 1

select distinct name from dbo.t_xref
where type = 'element property'
select * from dbo.t_xrefsystem
select * from dbo.t_attribute
where object_id = 17789