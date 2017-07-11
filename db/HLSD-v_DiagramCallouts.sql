
IF OBJECT_ID('HLSD.v_DiagramCallouts', 'V') IS NOT NULL 
     DROP VIEW HLSD.v_DiagramCallouts;   
GO

CREATE VIEW HLSD.v_DiagramCallouts AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 do.Diagram_ID
		,do.sequence		AS DisplaySequence
		,o.Alias							
		,o.Name
		,o.Note				AS "Notes.Formatted" 
FROM	t_diagram			d	
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id

WHERE	o.stereotype	= 'Callout'
GO

SELECT * FROM HLSD.v_DiagramCallouts