SELECT DISTINCT subj		
	,pred
	,obj


FROM (
		SELECT DISTINCT   subj			=	a.ResearchPatientId	
				,patient				=	CAST(a.ResearchPatientId	AS VARCHAR(64))				
				,institute				=	CAST(DataProviderInstitute	AS VARCHAR(64))
				,ConsentStatus			=	CAST(Trim(ConsentStatus)	AS VARCHAR(64))
				,ConsentType			=   CAST(Trim(ConsentType)		AS VARCHAR(64))

	FROM Hospfair.Patient a
	WHERE ResearchPatientId = '{}'

) pvt

UNPIVOT (
	obj FOR pred IN (
					patient
					,institute
					,ConsentStatus			
					,ConsentType
					)
) AS unpiv