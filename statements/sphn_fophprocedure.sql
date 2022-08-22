SELECT subj
		,pred
		,obj

FROM (	SELECT DISTINCT 

			subj						= 	UniqueId	
		    ,fall						=	CAST(ResearchCaseId		AS VARCHAR(64))
			,patient					=	CAST(ResearchPatientId	AS VARCHAR(64))		
			,institute					=	CAST('CHE_108_904_325'	AS VARCHAR(64))
			,ProcedureCodingDateTime	=	CAST(CONVERT(NVARCHAR(32),[CodingDateTime], 126) AS VARCHAR(64))
			,ChopProcedure				=	CAST([Procedure]						AS VARCHAR(64))
			,ProcedureBodySite			=	CASE
												WHEN BodySite IS NULL	THEN NULL
												ELSE CAST(CONCAT(Trim(BodySite), '_', Trim(Laterality))	AS VARCHAR(64))
											END
			,ProcedureRank				=	CASE
												WHEN ProcdeureRank = 'supplementary'	THEN	CAST('Supplementary'	AS VARCHAR(64))
												WHEN ProcdeureRank = 'principal'		THEN	CAST('Principal'		AS VARCHAR(64))
												ELSE NULL
											END
			,ProcedureIntent			=	CAST(ProcedureIntent					AS VARCHAR(64))

		FROM [RDSC_HOSPFAIR].[Hospfair].[FophProcedure]
		WHERE ResearchPatientId = '{}'
		AND [Procedure] IS NOT NULL
	
) pvt
UNPIVOT (obj FOR pred IN (fall
                        ,patient
                        ,institute
                        ,ProcedureCodingDateTime
                        ,ChopProcedure
                        ,ProcedureRank
						,ProcedureBodySite
						,ProcedureIntent
                        )
) unpiv


