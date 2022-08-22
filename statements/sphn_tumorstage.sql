SELECT DISTINCT subj
		,pred			
		,obj	

FROM (
		SELECT DISTINCT
           subj									=	UniqueId        
            ,patient							=	CAST(ResearchPatientId			AS VARCHAR(64)) 
            ,institute							=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall								=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,TumorStageAssessmentDateTime		=	CAST(CONVERT(NVARCHAR(64), [AssessmentDateTime]	, 126) AS VARCHAR(64)) 
			,Stage								=	CASE
														WHEN LEFT(CodingSystemVersion, 6) = 'SNOMED' THEN CAST(CONCAT('snomed:', Stage) AS VARCHAR(64)) 
														ELSE CAST(CONCAT(CodingSystemVersion, '_', Stage) AS VARCHAR(64)) 
													END				

        FROM Hospfair.TumorStage
		WHERE ResearchPatientId = '{}'
		AND Stage IS NOT NULL

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						  ,TumorStageAssessmentDateTime	
						  ,Stage		
						  	
						 )
) unpiv
