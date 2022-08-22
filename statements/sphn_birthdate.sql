SELECT DISTINCT subj
    ,pred
    ,obj

FROM (	

	SELECT DISTINCT 
		subj					=	a.ResearchPatientId	
		,patient				=	CAST(a.ResearchPatientId											AS VARCHAR(64))			
		,TimeOfBirth			=	CAST(TimeOfBirth													AS VARCHAR(64))
		,DayOfBirth				=	CAST(DayOfBirth														AS VARCHAR(64))
		,MonthOfBirth			=	CAST(DateName( month , DateAdd( month , MonthOfBirth , 0 ) - 1 )	AS VARCHAR(64))
		,YearOfBirth			=	CAST(YearOfBirth													AS VARCHAR(64))
		,DateOfBirthComparator	=	CASE
										WHEN DateOfBirthComparator	= '='	THEN	CAST('Equal'		AS VARCHAR(64))
										WHEN DateOfBirthComparator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
										WHEN DateOfBirthComparator	= '<'	THEN	CAST('LessThan'		AS VARCHAR(64))
										WHEN DateOfBirthComparator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
										WHEN DateOfBirthComparator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
										ELSE NULL
									END

	FROM Hospfair.Patient a
	WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient
                         ,DateOfBirthComparator
						 ,TimeOfBirth
						 ,DayOfBirth	
						 ,MonthOfBirth
						 ,YearOfBirth
			
                         )
) unpiv