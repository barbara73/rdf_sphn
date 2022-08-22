SELECT DISTINCT subj		
	,pred
	,obj


FROM (
		SELECT DISTINCT   subj			=	a.ResearchPatientId	
				,patient				=	CAST(a.ResearchPatientId	AS VARCHAR(64))				
				,CivilStatus			=	CAST(Trim(CivilStatus)		AS VARCHAR(64))

	FROM Hospfair.Patient a
	WHERE ResearchPatientId = '{}'


) pvt

UNPIVOT (
	obj FOR pred IN (
					patient
					,CivilStatus			
				
					)
) AS unpiv

