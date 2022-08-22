SELECT subj	
	,pred		
	,obj

FROM (	SELECT DISTINCT
            subj					=	Trim(TimePattern)
            ,TimePatternType		=	CAST(Trim(TimePattern)	AS VARCHAR(64))
	     
        FROM Hospfair.DrugAdministrationEvent a
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (TimePatternType)
) unpiv

