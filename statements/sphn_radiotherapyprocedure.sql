SELECT DISTINCT subj
		,pred			
		,obj	
	
FROM (
		SELECT DISTINCT
           subj						=	UniqueId        
            ,patient				=	CAST(ResearchPatientId			AS VARCHAR(64)) 
            ,institute				=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall					=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,RTStartDateTime		=	CAST(CONVERT(NVARCHAR(64), [StartDateTime]	, 126)	AS VARCHAR(64)) 
			,RTEndDateTime			=	CAST(CONVERT(NVARCHAR(64), [EndDateTime]	, 126)	AS VARCHAR(64)) 
			,RTCodingDateTime		=	CAST(CONVERT(NVARCHAR(64), [CodingDateTime]	, 126)	AS VARCHAR(64)) 
			,RTCode					=	CAST([Procedure]									AS VARCHAR(64)) 	
			,TargetBodySite			=	CASE
			                                WHEN TargetBodySite IS NULL   THEN NULL
			                                ELSE CAST(CONCAT(Trim(TargetBodySite), '_', Trim(Laterality))		AS VARCHAR(64))
			                            END
			,FractionsNumber		=	CAST(CONCAT(FractionsNumber, FractionsNumberUnitUCUM, FractionsNumberComperatorText) AS VARCHAR(64)) 
			,RadiationQuantity		=	CAST(CONCAT(RadiationQuantity, RadiationQuantityUnitUCUM, RadiationQuantityComperatorText) AS VARCHAR(64)) 

        FROM Hospfair.RadiotherapyProcedure
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						  ,RTStartDateTime	
						  ,RTEndDateTime		
						  ,RTCodingDateTime
						  ,RTCode				
						  ,TargetBodySite		
						  ,FractionsNumber	
						  ,RadiationQuantity

						 )
) unpiv