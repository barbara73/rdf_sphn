
SELECT subj
    ,pred
    ,obj

FROM (	
	SELECT DISTINCT subj				=	CONCAT(a.ResearchCaseId, [AgeDeterminationDateTime])
			,patient					=	CAST(a.ResearchPatientId	AS VARCHAR(64))
			,AgeDeterminationDateTime	=	CAST(CONVERT(NVARCHAR(32),[AgeDeterminationDateTime], 126) AS VARCHAR(64))
			,Age						=	CAST(CONCAT(DATEDIFF(Year, 
											cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
											AgeDeterminationDateTime), AgeUnitUCUM, AgeComperatorText) AS VARCHAR(64))

		FROM Hospfair.FophDiagnosis a

			LEFT JOIN Hospfair.Patient b
			ON a.ResearchPatientId = b.ResearchPatientId

		WHERE a.ResearchPatientId IN  {}
		AND DATEDIFF(Year, cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
			AgeDeterminationDateTime) IS NOT NULL


		UNION

		SELECT DISTINCT subj			=	CONCAT(a.ResearchCaseId, [AgeDeterminationDateTime])
			,patient					=	CAST(a.ResearchPatientId	AS VARCHAR(64))
			,AgeDeterminationDateTime	=	CAST(CONVERT(NVARCHAR(32),[AgeDeterminationDateTime], 126) AS VARCHAR(64))
			,Age						=	CAST(CONCAT(DATEDIFF(Year, 
											cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
											AgeDeterminationDateTime), AgeUnitUCUM, AgeComperatorText) AS VARCHAR(64))

		FROM Hospfair.ICDODiagnosis a

			LEFT JOIN Hospfair.Patient b
			ON a.ResearchPatientId = b.ResearchPatientId

		WHERE a.ResearchPatientId IN  {}
		AND DATEDIFF(Year, cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
			AgeDeterminationDateTime) IS NOT NULL


		UNION

		SELECT DISTINCT subj			=	CONCAT(a.ResearchCaseId, [AgeDeterminationDateTime])
			,patient					=	CAST(a.ResearchPatientId	AS VARCHAR(64))
			,AgeDeterminationDateTime	=	CAST(CONVERT(NVARCHAR(32),[AgeDeterminationDateTime], 126) AS VARCHAR(64))
			,Age						=	CAST(CONCAT(DATEDIFF(Year, 
											cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
											AgeDeterminationDateTime), AgeUnitUCUM, AgeComperatorText) AS VARCHAR(64))

		FROM Hospfair.NursingDiagnosis a

			LEFT JOIN Hospfair.Patient b
			ON a.ResearchPatientId = b.ResearchPatientId

		WHERE a.ResearchPatientId = '{}'
		AND DATEDIFF(Year, cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
			AgeDeterminationDateTime) IS NOT NULL
			
			
) pvt
UNPIVOT (obj FOR pred IN (patient	
						  ,Age
						  ,AgeDeterminationDateTime

                         )
) unpiv
