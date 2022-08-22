SELECT subj
	,pred
	,obj


FROM (	SELECT DISTINCT
             subj				=	CONCAT(UniqueId_ReferenceRange, '_', QuantitativeResultUnitUCUM)    

            ,UpperLimit			=	CASE 
										WHEN UpperLimit IS NULL		THEN NULL
										ELSE CAST(CONCAT(UpperLimit, UpperLimitUnitUCUM, UpperLimitComperatorText) AS VARCHAR(64)) 
									END
            ,LowerLimit			=	CASE 
										WHEN LowerLimit IS NULL	    THEN NULL
										ELSE CAST(CONCAT(LowerLimit, LowerLimitUnitUCUM, LowerLimitComperatorText) AS VARCHAR(64)) 
									END
           
		FROM Hospfair.LabResult
		WHERE ResearchPatientId = '{}'
		AND UniqueId_ReferenceRange is not NULL
			AND NOT (UpperLimit IS NULL AND LowerLimit IS NULL)


) pvt
UNPIVOT (obj FOR pred IN (UpperLimit
							,LowerLimit
							)

) unpiv