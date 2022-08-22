With stage_foph_diagnosis As
(	SELECT a.ResearchPatientId
		,UniqueId
		,ResearchCaseId
		,Diagnosis					=	CAST(Diagnosis AS VARCHAR(64))
		,DiagnosisRank				=	CASE	
											WHEN DiagnosisRank = 'secondary'	THEN	CAST('Secondary' AS VARCHAR(64))
											WHEN DiagnosisRank = 'principal'	THEN	CAST('Principal' AS VARCHAR(64))
											ELSE NULL
										END
		--,DiagnosisSubjectAge		=	CASE
		--									WHEN DATEDIFF(Year, cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
		--										AgeDeterminationDateTime) IS NULL		THEN NULL
		--									ELSE CAST(CONCAT(a.ResearchCaseId, [AgeDeterminationDateTime]) AS VARCHAR(64))
		--								END
		,DiagnosisCodingDateTime	=	CAST(CONVERT(NVARCHAR(64), CodingDateTime, 126) AS VARCHAR(64))

	FROM Hospfair.FophDiagnosis a

		LEFT JOIN Hospfair.Patient b
		ON a.ResearchPatientId = b.ResearchPatientId

	WHERE a.ResearchPatientId = '{}'
	AND Diagnosis IS NOT NULL

)

SELECT subj
    ,pred
    ,obj

FROM (	SELECT DISTINCT
			subj						=	UniqueId
			,fall						=	CAST(ResearchCaseId		AS VARCHAR(64))
			,patient					=	CAST(ResearchPatientId	AS VARCHAR(64))
			,institute					=	CAST('CHE_108_904_325'	AS VARCHAR(64))
			,Diagnosis					
			,DiagnosisCodingDateTime
			,DiagnosisRank
			--,DiagnosisSubjectAge		

		FROM stage_foph_diagnosis a


) pvt
UNPIVOT (obj FOR pred IN (fall
                         ,patient	
                         ,institute
						 ,Diagnosis	
                         ,DiagnosisCodingDateTime
						 ,DiagnosisRank
						 --,DiagnosisSubjectAge
                        
                         )
) unpiv