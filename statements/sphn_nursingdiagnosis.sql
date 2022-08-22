SELECT DISTINCT subj
		,pred			
		,obj	

FROM (
		SELECT DISTINCT   subj					=	UniqueId        
            ,patient							=	CAST(a.ResearchPatientId			AS VARCHAR(64)) 
            ,institute							=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall								=	CAST(a.ResearchCaseId				AS VARCHAR(64)) 
			,NursingDiagnosisCode				=	CAST(CONCAT([DiagnosisCodingSystemVersion], '_', Diagnosis)	AS VARCHAR(64)) 
			,NursingDiagnosisRecordDateTime		=	CAST(CONVERT(NVARCHAR(64), [RecordingDateTime]	, 126)		AS VARCHAR(64)) 
			,NursingDiagnosisCodingDateTime		=	CAST(CONVERT(NVARCHAR(64), [CodingDateTime]	, 126)			AS VARCHAR(64)) 
			--,NursingDiagnosisAge				=	CASE
			--											WHEN DATEDIFF(Year, cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
			--												AgeDeterminationDateTime) IS NULL		THEN NULL
			--											ELSE CAST(CONCAT(a.ResearchCaseId, [AgeDeterminationDateTime]) AS VARCHAR(64))
			--										END
			
		  FROM [RDSC_HOSPFAIR].[Hospfair].[NursingDiagnosis] a
		  
			LEFT JOIN Hospfair.Patient b
			ON a.ResearchPatientId = b.ResearchPatientId

		  WHERE a.ResearchPatientId = '{}'
		  AND Diagnosis IS NOT NULL

) pvt
UNPIVOT (obj FOR pred IN (patient			
						  ,institute			
						  ,fall				
						 ,NursingDiagnosisCode					
						 ,NursingDiagnosisRecordDateTime
						 ,NursingDiagnosisCodingDateTime
						 --,NursingDiagnosisAge			
						 
						 )
) unpiv
