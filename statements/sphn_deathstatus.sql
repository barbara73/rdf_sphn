SELECT DISTINCT subj
	,pred
	,obj


FROM (SELECT DISTINCT
             subj					=	a.ResearchPatientId	
			,patient				=	CAST(a.ResearchPatientId			AS VARCHAR(64))				
			,DateOfDeath			=	CASE
											WHEN TimeOfDeath IS NULL
												AND DayOfDeath IS NULL
												AND MonthOfDeath IS NULL
												AND YearOfDeath IS NULL
												AND TimeOfDeath IS NULL		THEN NULL
											ELSE CAST(a.ResearchPatientId	AS VARCHAR(64))  
										END
            ,DeathStatus			=	CAST(Trim(DeathStatus)				AS VARCHAR(64))

  FROM Hospfair.Patient a
  WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient
                         ,DateOfDeath
                         ,DeathStatus
                         )
) unpiv