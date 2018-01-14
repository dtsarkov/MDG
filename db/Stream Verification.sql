SELECT sid.Value as StreamID
		,spkg.*

FROM t_object		sobj

JOIN t_package						spkg
ON	spkg.ea_guid = sobj.ea_guid

JOIN t_objectproperties             sid
ON		sobj.Object_ID	= sid.Object_ID
and		sid.Property = 'TCF::Stream ID'

WHERE	sobj.Stereotype  = 'TCF Stream'
and		sid.Value		in ('1265')


--select * from t_package where Name = 'GRD Hierarchies (417)'

-- Check stream Database Objects 
-- ------------------------------------------------------------------------------
select	 dbp1.Name		as DBName
		,dbo0.Name		as DBObjectName
		,dbo0.Stereotype
		,dbo0.Note		as DBObjectNote
FROM t_object		dbp0

JOIN t_package		dbp1
ON	dbp0.ea_guid = dbp1.ea_guid

JOIN t_object		dbo0
ON	dbo0.Package_ID	= dbp1.Package_ID

where dbp1.parent_id = 1130