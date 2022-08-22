SELECT DISTINCT subj
		,pred			
		,obj	

FROM (
		SELECT DISTINCT   subj					=	UniqueId        
            ,patient							=	CAST(a.ResearchPatientId			AS VARCHAR(64)) 
            ,institute							=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall								=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,TopographyCode						=	CAST(CONCAT([TopographyCodingSystemVersion], '_', Topography)	AS VARCHAR(64)) 
			,MorphologyCode						=	CAST(CONCAT([MorphologyCodingSystemVersion], '_', Morphology)	AS VARCHAR(64)) 
			,ICDORecordDateTime					=	CAST(CONVERT(NVARCHAR(64), [RecordDateTime]	, 126)				AS VARCHAR(64)) 
			,DiagnosisCodingDateTime			=	CAST(CONVERT(NVARCHAR(64), [CodingDateTime]	, 126)				AS VARCHAR(64)) 
			--,SubjectAge							=	CASE
			--											WHEN DATEDIFF(Year, cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
			--												AgeDeterminationDateTime) IS NULL		THEN NULL
			--											ELSE CAST(CONCAT(a.ResearchCaseId, [AgeDeterminationDateTime]) AS VARCHAR(64))
			--										END

		  FROM [RDSC_HOSPFAIR].[Hospfair].[ICDODiagnosis] a

			LEFT JOIN Hospfair.Patient b
			ON a.ResearchPatientId = b.ResearchPatientId

		WHERE a.ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						 ,TopographyCode			
						 ,MorphologyCode			
						 ,ICDORecordDateTime		
						 ,DiagnosisCodingDateTime
						 --,SubjectAge				
						 
						 )
) unpiv