IF OBJECT_ID('HLSD.v_element_efforts_by_diagram', 'V') IS NOT NULL 
     DROP VIEW HLSD.v_element_efforts_by_diagram;   
GO

CREATE VIEW HLSD.v_element_efforts_by_diagram AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT do.Diagram_ID
		,o.object_id
		,o.Package_ID
		,'<b>'+o.Name+'</b>'				as "Name.Formatted"
		,o.Alias							as "Alias.Formatted"
		,o.Note								as "Note.Formatted"
		,o.Stereotype
		,o.Object_Type	
		,o.Alias							as DisplaySequence
		,'<b>'
		+COALESCE(ee.EffortValue
				 ,op.Value
		 )
		+'</b>'								as "Effort.Formatted"
FROM t_diagramobjects		do

JOIN	t_object				o
ON	o.object_id	= do.object_id

LEFT JOIN	HLSD.v_element_efforts		ee
ON	ee.Object_ID = do.object_id
AND	ee.EffortType = 'Total'

LEFT JOIN t_objectproperties	op
ON	op.Object_ID	= o.Object_ID 
AND	op.Property = 'TotalEffort'

UNION ALL

SELECT do.Diagram_ID
		,o.object_id
		,o.Package_ID
		,'<b>'+ee.EffortType +': </b>' + ee.Effort
		,''									as Alias
		,ee."Notes.Formated"				as "Note.Formated"
		,o.Stereotype
		,o.Object_Type	
		,o.Alias+'-'+cast(ee.DisplaySequence as varchar(50))
		,CASE	WHEN ee.EffortValue = ''
				THEN '<b><font color="red">TBC</font></b>'
				ELSE ee.EffortValue
		 END								as EffortValue
		
FROM t_diagramobjects		do

JOIN	t_object				o
ON	o.object_id	= do.object_id

JOIN	HLSD.v_element_efforts		ee
ON	ee.Object_ID = do.object_id
AND	ee.EffortType <> 'Total'

--WHERE do.Object_ID = 18474
;
GO 
SELECT * FROM HLSD.v_element_efforts_by_diagram
where diagram_id in (select Diagram_ID from t_diagram where name = 'Supplier Risk Assesment (SRA) - solution overview') --'Business Outcome Base Facts - Changes' ) --
--WHERE Object_ID = 18474 
order by DisplaySequence

