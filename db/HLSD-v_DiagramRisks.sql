
IF OBJECT_ID('HLSD.v_DiagramRisks', 'V') IS NOT NULL 
     DROP VIEW HLSD.v_DiagramRisks;   
GO

CREATE VIEW HLSD.v_DiagramRisks AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
SELECT	 do.Diagram_ID
		,do.sequence		AS DisplaySequence
		,o.Alias							
		,o.Name
		,o.Note				AS "Note.Formatted" 
FROM	t_diagram			d	
JOIN	t_diagramobjects	do	ON d.diagram_id		= do.diagram_id
JOIN	t_object			o	ON o.object_id		= do.object_id

WHERE	o.Object_Type	= 'Risk'
GO

SELECT * FROM HLSD.v_DiagramRisks