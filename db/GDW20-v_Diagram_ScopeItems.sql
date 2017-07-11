
IF OBJECT_ID('GDW20.v_Diagram_ScopeItems', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_Diagram_ScopeItems;   
GO

CREATE VIEW GDW20.v_Diagram_ScopeItems AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 coalesce(o.Alias
				 ,cast(do.Sequence as varchar(255))
		 )								as ItemID
		,d.Diagram_ID					
		,o.Name							as ItemName
		,o.Note							as "Note.Formatted"
		,o.Status
		
FROM	t_diagram			d	
JOIN	t_package			pkg	ON pkg.package_id	= d.package_id
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id

where o.stereotype = 'Scope Item'


