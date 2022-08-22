SELECT subj
		,pred
		,obj
		
FROM (	SELECT subj
               ,Intent

        FROM (  SELECT DISTINCT
                    subj			= 	TRIM(ProcedureIntent)
                    ,Intent			=	CAST(TRIM(ProcedureIntent) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM [RDSC_HOSPFAIR].[Hospfair].[FophProcedure]

                UNION

                SELECT DISTINCT
                    subj			= 	TRIM(Intent)
                    ,Intent			=	CAST(TRIM(Intent) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM [RDSC_HOSPFAIR].[Hospfair].[DrugPrescription]
                ) a

        WHERE ResearchPatientId = '{}'

		-- unions for other intent
	
) pvt
UNPIVOT (obj FOR pred IN (Intent)
) unpiv
