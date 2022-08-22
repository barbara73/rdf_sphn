SELECT subj					
		,pred
		,obj


FROM (
	SELECT DISTINCT subj	=	CurrentLocationExact
		,institute			=	CAST('CHE_108_904_325'			AS VARCHAR(64))
		,LocationClass		=	CAST([CurrentLocationClass]		AS VARCHAR(64))
		,LocationExact		=	CAST([CurrentLocationExact]		AS VARCHAR(64))

	  FROM [RDSC_HOSPFAIR].[Hospfair].[HealthcareEncounter] a
	  WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (
						institute		
						,LocationClass
						,LocationExact
						)
					) unpiv
		