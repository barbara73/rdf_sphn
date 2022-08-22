SELECT subj
		,pred
		,obj
		

FROM (	SELECT subj
            ,BodySite
            ,BodySiteLaterality
        FROM (

                SELECT DISTINCT

                    subj					= 	CONCAT(Trim(BodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(BodySite)		AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM [Hospfair].[FophProcedure]
                WHERE BodySite IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					= 	'113257007'
                    ,BodySite				=	CAST('113257007'	AS VARCHAR(64))
                    ,BodySiteLaterality		=	CAST(NULL			AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.BloodPressure a
                WHERE BodySite IS NOT NULL


                UNION

                SELECT DISTINCT
                    subj					= 	CONCAT(Trim(BodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(BodySite)		AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM Hospfair.BodyTemperature a
                WHERE BodySite IS NOT NULL


                UNION

                SELECT DISTINCT
                    subj					= 	CONCAT(Trim(BodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(BodySite)		AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM Hospfair.LabResult a
                WHERE BodySite IS NOT NULL


                UNION

                SELECT DISTINCT
                    subj					= 	CONCAT(Trim(BodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(BodySite)		AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM Hospfair.HeartRate a
                WHERE BodySite IS NOT NULL


                UNION

                SELECT DISTINCT
                    subj					= 	CONCAT(Trim(BodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(BodySite)		AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM Hospfair.OxygenSaturation a
                WHERE BodySite IS NOT NULL


                UNION

                SELECT DISTINCT
                    subj					= 	CONCAT(Trim(TargetBodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(TargetBodySite)	AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM Hospfair.RadiotherapyProcedure a
                WHERE TargetBodySite IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					= 	CONCAT(Trim(ProgressionBodySite), '_', Trim(Laterality))
                    ,BodySite				=	CAST(Trim(ProgressionBodySite)	AS VARCHAR(64))
                    ,BodySiteLaterality		=	CASE
                                                    WHEN Laterality = '261665006'    THEN NULL
                                                    ELSE CAST(Trim(Laterality)			AS VARCHAR(64))
                                                END
                    ,ResearchPatientId

                FROM Hospfair.OncologyTreatmentAssessment a
                WHERE ProgressionBodySite IS NOT NULL
		) a

WHERE ResearchPatientId = '{}'
		-- unions for other intent
	
) pvt
UNPIVOT (obj FOR pred IN (BodySite
						,BodySiteLaterality)
) unpiv