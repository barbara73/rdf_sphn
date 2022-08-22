SELECT subj					
		,pred
		,obj


FROM (	 SELECT DISTINCT subj			=		[UniqueId]
			  ,institute				=		CAST('CHE_108_904_325'			AS VARCHAR(64))
			  ,patient					=		CAST(a.ResearchPatientId		AS VARCHAR(64))
			  ,fall						=		CAST([ResearchCaseId]			AS VARCHAR(64))
			  ,HCUniqueId				=		CAST([UniqueId]					AS VARCHAR(64))
			  ,HCStartDateTime			=		CAST(CONVERT(NVARCHAR(32),[StartDateTime], 126)		AS VARCHAR(64))
			  ,HCEndDateTime			=		CAST(CONVERT(NVARCHAR(32),[EndDateTime], 126)		AS VARCHAR(64))
			  ,HCTherapeuticArea		=		CAST([TherapeuticArea]			AS VARCHAR(64))
			  ,CurrentLocation			=		CAST([CurrentLocationExact]		AS VARCHAR(64))
    
		FROM [RDSC_HOSPFAIR].[Hospfair].[HealthcareEncounter] a
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (
						institute		
						,HCUniqueId
						,patient	
						,fall
						,HCStartDateTime		
						,HCEndDateTime			
						,HCTherapeuticArea		
						,CurrentLocation
					)
) unpiv