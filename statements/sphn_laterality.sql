SELECT subj
		,pred
		,obj


FROM (	SELECT subj
            ,Laterality

        FROM (

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM [RDSC_HOSPFAIR].[Hospfair].[FophProcedure]

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.BloodPressure a

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.BodyTemperature a

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.LabResult a

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.HeartRate a

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.OxygenSaturation a

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.RadiotherapyProcedure a

                UNION

                SELECT DISTINCT
                    subj			= 	Trim(Laterality)
                    ,Laterality		=	CAST(Trim(Laterality) AS VARCHAR(64))
                    ,ResearchPatientId

                 FROM Hospfair.OncologyTreatmentAssessment a

		 ) b
		 WHERE ResearchPatientId = '{}'
		    AND Laterality IS NOT NULL
		    AND Laterality <> '261665006'

	
) pvt
UNPIVOT (obj FOR pred IN (Laterality)
) unpiv
