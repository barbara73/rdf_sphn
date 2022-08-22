SELECT subj					
		,pred
		,obj


FROM (
	SELECT DISTINCT subj		=	Trim(' ' FROM CareHandlingType)
		,CareHandlingType		=	CAST(Trim(' ' FROM CareHandlingType)	AS VARCHAR(64))

	  FROM [RDSC_HOSPFAIR].[Hospfair].[AdministrativeCase] a
	  WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (CareHandlingType)) unpiv