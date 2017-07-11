IF OBJECT_ID('GDW20.v_AncestorTable', 'V') IS NOT NULL 
     DROP VIEW GDW20.v_AncestorTable;   
GO

CREATE VIEW GDW20.v_AncestorTable AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 o.object_id
		,o.Name
		,o.Stereotype
		,p.Object_ID					AS ancestor_id
		,coalesce(p.Alias,p.Name)		AS ancestor_name
		,rank() over(
					partition by o.object_id 
					order	  by coalesce(p.Alias,p.Name)
				)						AS ancestor_rank
FROM	t_object			o	
JOIN	t_connector			c	ON c.start_object_id	= o.object_id		and c.connector_type = 'Generalization'
JOIN	t_object			p	ON p.object_id			= c.end_object_id	and	p.stereotype	 = 'table'


where o.stereotype	in ('table','view')
;
GO 

SELECT * FROM GDW20.v_AncestorTable 