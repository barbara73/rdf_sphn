SELECT DISTINCT subj
		,pred			
		,obj	
	

FROM (
		SELECT DISTINCT
           subj									=	UniqueId        
            ,patient							=	CAST(ResearchPatientId			AS VARCHAR(64)) 
            ,institute							=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall								=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,TumorGradeAssessmentDateTime		=	CAST(CONVERT(NVARCHAR(64), [AssessmentDateTime]	, 126) AS VARCHAR(64)) 
			,Grade								=	CASE
														WHEN LEFT(CodingSystemVersion, 6) = 'SNOMED' THEN CAST(CONCAT('snomed:', Grade) AS VARCHAR(64)) 
														ELSE CAST(CONCAT(CodingSystemVersion, '_', Grade) AS VARCHAR(64)) 
													END				

        FROM Hospfair.TumorGrade
		WHERE ResearchPatientId = '{}'
		AND Grade is NOT NULL

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						  ,TumorGradeAssessmentDateTime	
						  ,Grade			
						  	
						 )
) unpiv
