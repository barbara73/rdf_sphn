SELECT subj
    ,pred
    ,obj

FROM (	SELECT DISTINCT
			subj						=	UniqueId
			,patient					=	CAST(ResearchPatientId	AS VARCHAR(64)) 
            ,institute					=	CAST('CHE_108_904_325'	AS VARCHAR(64)) 
            ,fall						=	CAST(ResearchCaseId		AS VARCHAR(64)) 
            ,SystolicPressure			=	CASE
												WHEN SystolicPressure is NULL	THEN NULL
												ELSE CAST(CONCAT(SystolicPressure, SystolicUnitUCUM, SystolicComperatorText)	AS VARCHAR(64)) 
											END
            ,DiastolicPressure			=	CASE
												WHEN DiastolicPressure is NULL	THEN NULL
												ELSE CAST(CONCAT(DiastolicPressure, DiastolicUnitUCUM, DiastolicComperatorText)	AS VARCHAR(64)) 
											END
            ,MeanPressure				=	CASE
												WHEN MeanPressure is NULL	THEN NULL
												ELSE CAST(CONCAT(MeanPressure, MeanUnitUCUM, MeanComperatorText)				AS VARCHAR(64)) 
											END
            ,PressureDateTime			=	CAST(CONVERT(NVARCHAR(64), [DateTime], 126)				AS VARCHAR(64))
            ,PressureBodySite			=	CAST('113257007'										AS VARCHAR(64))
            ,PressureMeasurementMethod	=	CAST(Trim(MeasurementMethod)							AS VARCHAR(64)) 

        FROM Hospfair.BloodPressure a
		WHERE ResearchPatientId = '{}'
		AND NOT (SystolicPressure IS NULL AND DiastolicPressure IS NULL AND MeanPressure IS NULL)
      

) pvt
UNPIVOT (obj FOR pred IN (patient
                        ,institute
                        ,fall
                        ,SystolicPressure
						,DiastolicPressure
						,MeanPressure
						,PressureDateTime			
						,PressureBodySite			
						,PressureMeasurementMethod
                        )
) unpiv
