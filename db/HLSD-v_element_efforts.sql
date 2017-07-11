IF OBJECT_ID('HLSD.v_element_efforts', 'V') IS NOT NULL 
     DROP VIEW HLSD.v_element_efforts;   
GO

CREATE VIEW HLSD.v_element_efforts AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT ee.object_id
		,ee.EffortType
		,CASE WHEN ee.EffortType = 'Total'
			  THEN 'Overall Estimated Effort'
			  ELSE COALESCE(et.Description,'- Unknown -')	
		 END												AS EffortTypeX
		,ee.Effort
		,ee.Notes											AS "Notes.Formated"
		,COALESCE(et.NumericWeight*100,9999)				AS DisplaySequence
		,ee.EffortValue
FROM (
	SELECT   de.object_id
			,de.EffortType
			,de.Effort
			,de.Notes
			,CASE WHEN de.EffortValue = 0
				  THEN ''
				  ELSE CAST(de.EffortValue as VARCHAR(50))
			 END + COALESCE(ue.EffortValue,'')
													AS EffortValue
	FROM (
		SELECT	 oe.Object_ID
				,oe.EffortType
				,oe.Effort
				,oe.Notes
				,oe.EValue				as EffortValue
		FROM t_objecteffort oe
--		WHERE oe.EValue > 0
		UNION ALL
		SELECT	 oe.Object_ID
				,'Total'					as EffortType
				,''							as Effort
				,''							as Notes
				,SUM(oe.EValue)				as EffortValue
		FROM t_objecteffort oe
		GROUP BY oe.Object_ID
	) de
	LEFT JOIN (
		SELECT	 oe.Object_ID
				,''					as Effort
				,'Total'			as EffortType
				,''					as Notes
				,'+'				as EffortValue
		FROM t_objecteffort oe
		WHERE oe.EValue <= 0
		GROUP BY oe.Object_ID

	) ue
	ON	de.Object_ID	= ue.Object_ID
	AND	de.EffortType	= ue.EffortType
	
) ee

LEFT JOIN t_efforttypes		et
ON	et.EffortType = ee.EffortType

GO


select * from HLSD.v_element_efforts
where OBJECT_ID = 18474
ORDER BY object_id, displaysequence	

