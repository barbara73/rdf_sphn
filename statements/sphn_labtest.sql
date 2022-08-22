SELECT subj
	,pred
	,obj


FROM (	SELECT DISTINCT
             subj						=	UniqueId_LabTest   
			,patient					=	CAST(ResearchPatientId		AS VARCHAR(64)) 
            ,institute					=	CAST('CHE_108_904_325'		AS VARCHAR(64)) 
			,fall						=	CAST(ResearchCaseId			AS VARCHAR(64)) 
			,LabTest					=	CAST(LabTest				AS VARCHAR(64))
           
		FROM Hospfair.LabResult
		WHERE ResearchPatientId = '{}'
		AND LabTest is not NULL


) pvt
UNPIVOT (obj FOR pred IN (patient	
						  ,institute	
						  ,fall		
							,LabTest	
							)

) unpiv