SELECT subj
    ,pred
    ,obj


FROM (	SELECT DISTINCT
			subj						=	UniqueId
			,patient					=	CAST(ResearchPatientId	AS VARCHAR(64)) 
            ,institute					=	CAST('CHE_108_904_325'	AS VARCHAR(64)) 
            ,fall						=	CAST(ResearchCaseId		AS VARCHAR(64)) 
            ,HeartRate					=	CASE
			                                    WHEN Value IS NULL  THEN NULL
			                                    ELSE CAST(CONCAT([Value], UnitUCUM, ComperatorText)	AS VARCHAR(64))
			                                END
			,Regularity					=	CAST(Trim(Regularity)			AS VARCHAR(64)) 					
            ,PhysiologicalState			=	CAST(Trim(PhysiologicState)		AS VARCHAR(64)) 
										
            ,HeartRateDateTime			=	CAST(CONVERT(NVARCHAR(64), [ObservationDateTime], 126)			AS VARCHAR(64))
            ,HeartRateBodySite			=	CASE
												WHEN BodySite IS NULL	THEN NULL
												ELSE CAST(CONCAT(Trim(BodySite), '_', Trim(Laterality))		AS VARCHAR(64)) 
											END
            ,HeartRateMeasurementMethod	=	CAST(Trim(MeasurementMethod)	AS VARCHAR(64)) 

        FROM Hospfair.HeartRate a
		WHERE ResearchPatientId = '{}'
		AND VALUE IS NOT NULL
      

) pvt
UNPIVOT (obj FOR pred IN (patient
                        ,institute
                        ,fall
                        ,HeartRate
						,Regularity
						,PhysiologicalState
						,HeartRateDateTime			
						,HeartRateBodySite			
						,HeartRateMeasurementMethod
                        )
) unpiv
