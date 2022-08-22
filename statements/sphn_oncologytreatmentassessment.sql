SELECT DISTINCT subj
		,pred			
		,obj	

FROM (
		SELECT DISTINCT
           subj									=	UniqueId        
            ,patient							=	CAST(ResearchPatientId			AS VARCHAR(64)) 
            ,institute							=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall								=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,OncologyAssessmentDateTime			=	CAST(CONVERT(NVARCHAR(64), [AssessmentDateTime]	, 126) AS VARCHAR(64)) 
			,AssessmentCriteria					=	CAST(Criteria					AS VARCHAR(64)) 
			,ProgressionType					=	CAST(ProgressionType			AS VARCHAR(64))						
			,ProgressionBodySite				=	CASE
														WHEN ProgressionBodySite IS NULL	THEN NULL
														ELSE CAST(CONCAT(ProgressionBodySite, '_', Laterality)		AS VARCHAR(64)) 
													END
			,AssessmentMethod					=	CAST(AssessmentMethod			AS VARCHAR(64))
			,AssessmentResult					=	CAST(Result						AS VARCHAR(64))

        FROM Hospfair.OncologyTreatmentAssessment
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						  ,OncologyAssessmentDateTime	
						  ,AssessmentCriteria	
						  ,ProgressionType	
						  ,ProgressionBodySite
						  ,AssessmentMethod	
						  ,AssessmentResult	
					
						 )
) unpiv