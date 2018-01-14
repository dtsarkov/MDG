IF OBJECT_ID('HLSD.v_element_efforts', 'V') IS NOT NULL 
     DROP VIEW HLSD.v_element_efforts;   
GO

CREATE VIEW HLSD.v_element_efforts AS
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------

SELECT ee.object_id
		,ee.EffortType
		,CASE WHEN ee.EffortType = 'Total'
			  THEN 'Total'
			  ELSE COALESCE(et.Description,'- Unknown -')	
		 END												AS EffortTypeX
		,COALESCE(et.NumericWeight*100,9999)				AS DisplaySequence
		,ee.EffortValue
FROM (
	SELECT   COALESCE(de.object_id, ue.object_id)		AS object_id
			,COALESCE(de.EffortType, ue.EffortType)		AS EffortType
			,CASE WHEN de.EffortValue IS NULL
				  THEN COALESCE(ue.EffortValue,'')
				  ELSE CAST(de.EffortValue as VARCHAR(50))
					  +CASE WHEN ue.EffortValue IS NULL 
							THEN '' ELSE '+'
					   END
			 END 
													AS EffortValue
	FROM (
		SELECT	 oe.Object_ID
				,CASE WHEN GROUPING(oe.EffortType) = 1 
					  THEN 'Total'
					  ELSE oe.EffortType
				 END						as EffortType
				,SUM(oe.EValue)				as EffortValue
				,COUNT(*)					as EffortCount
		FROM t_objecteffort oe
		WHERE oe.EValue > 0
		GROUP BY oe.Object_ID, ROLLUP(oe.EffortType)
	) de
	FULL JOIN (
		SELECT	 oe.Object_ID
				,'Total'			as EffortType
				,'TBC'				as EffortValue
		FROM t_objecteffort oe
		WHERE oe.EValue <= 0
		GROUP BY oe.Object_ID

		UNION ALL
		SELECT	 oe.Object_ID
				,oe.EffortType
				,'TBC'				as EffortValue
		FROM t_objecteffort oe
		WHERE oe.EValue <= 0
		GROUP BY oe.Object_ID, oe.EffortType
	) ue
	ON	de.Object_ID	= ue.Object_ID
	AND	de.EffortType	= ue.EffortType
) ee
LEFT JOIN t_efforttypes		et
ON	et.EffortType = ee.EffortType

GO

select * from HLSD.v_element_efforts
ORDER BY object_id, displaysequence	

