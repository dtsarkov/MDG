/*
IF OBJECT_ID('GDW20.v_Kaizen_EntityDefinitions', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Kaizen_EntityDefinitions;   
GO

CREATE VIEW GDW20.v_Kaizen_EntityDefinitions AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
*/
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


WHERE	d.StyleEx		like '%GDW 2.0 Diagrams::Physical Data Model%'
and		(o.stereotype	= 'Macro'
		)	
and		o.abstract		= 0
and		o.status		in ('Proposed','Modified')


SELECT	 ea_guid
		,SUBSTRING(Name,1, CHARINDEX(';',Name)-1)				AS Name
		,SUBSTRING(Type,1, CHARINDEX(';',Type)-1)				AS Type
		,CAST(SUBSTRING(Pos ,1, CHARINDEX(';',Pos)-1) AS int)	AS Pos
		
FROM (		
	SELECT SUBSTRING(Description,PATINDEX('%Name=%',Description)+5,255)	as Name
		,SUBSTRING(Description,PATINDEX('%ParameteredElementType=%',Description)+23,255)as Type
		,SUBSTRING(Description,PATINDEX('%Pos=%',Description)+4,255)	as Pos
		,Client as ea_guid
	FROM t_xref		
	WHERE Description like '%Type=ClassifierTemplateParameter%'
) X
ORDER BY ea_guid, pos