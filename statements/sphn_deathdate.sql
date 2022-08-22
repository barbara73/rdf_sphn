SELECT DISTINCT subj
    ,pred
    ,obj

FROM (	

	SELECT DISTINCT 
		subj					=	a.ResearchPatientId	
		,patient				=	CAST(a.ResearchPatientId											AS VARCHAR(64))		
		,TimeOfDeath			=	CAST(TimeOfDeath													AS VARCHAR(64))
		,DayOfDeath				=	CAST(DayOfDeath														AS VARCHAR(64))
		,MonthOfDeath			=	CAST(DateName( month , DateAdd( month , MonthOfDeath , 0 ) - 1 )	AS VARCHAR(64))
		,YearOfDeath			=	CAST(YearOfDeath													AS VARCHAR(64))
 

	FROM Hospfair.Patient a
	WHERE ResearchPatientId = '{}'
	AND (TimeOfDeath IS NOT NULL
		OR DayOfDeath IS NOT NULL
		OR MonthOfDeath IS NOT NULL
		OR YearOfDeath IS NOT NULL
		OR TimeOfDeath IS NOT NULL)


) pvt
UNPIVOT (obj FOR pred IN (patient
						 ,TimeOfDeath
						 ,DayOfDeath
						 ,MonthOfDeath
						 ,YearOfDeath
			
                         )
) unpiv