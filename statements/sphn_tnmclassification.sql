SELECT DISTINCT subj
		,pred			
		,obj	
	

FROM (
		SELECT DISTINCT
           subj						=	UniqueId        
            ,patient				=	CAST(ResearchPatientId			AS VARCHAR(64)) 
            ,institute				=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall					=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,AssessmentDateTime		=	CAST(CONVERT(NVARCHAR(64), [DateTime], 126) AS VARCHAR(64)) 
			,TNM					=	CAST(TNM						AS VARCHAR(64)) 
			,TPrefix				=	CAST(TPrefix					AS VARCHAR(64)) 
			,TSuffix				=	CAST(TSuffix					AS VARCHAR(64)) 
			,NPrefix				=	CAST(NPrefix					AS VARCHAR(64)) 
			,NSuffix				=	CAST(NSuffix					AS VARCHAR(64)) 
			,MPrefix				=	CAST(MPrefix					AS VARCHAR(64)) 
			,MSuffix				=	CAST(MSuffix					AS VARCHAR(64)) 
			,TNMVersion				=	CAST(CodingSystemVersion		AS VARCHAR(64)) 
							

        FROM Hospfair.TNMClassification
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						  ,AssessmentDateTime	
						  ,TNM				
						  ,TPrefix			
						  ,TSuffix			
						  ,NPrefix			
						  ,NSuffix			
						  ,MPrefix			
						  ,MSuffix			
						  ,TNMVersion			
						 )
) unpiv