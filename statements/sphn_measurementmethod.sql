SELECT subj
    ,pred
    ,obj


FROM (	SELECT
			subj
			,MeasurementMethod

		FROM (

			SELECT DISTINCT
                subj			        =	Trim(MeasurementMethod)
                ,MeasurementMethod		=	CASE
                                                WHEN Trim(MeasurementMethod) = 17146006 THEN CAST(46973005	AS VARCHAR(64)) --!!!!
                                                WHEN Trim(MeasurementMethod) = 77938009 THEN CAST(716777001	AS VARCHAR(64)) --!!!!
                                            END
                ,ResearchPatientId

            FROM Hospfair.BloodPressure a

            UNION

            SELECT DISTINCT
                subj						=	Trim(MeasurementMethod)
                ,MeasurementMethod			=	CAST(Trim(MeasurementMethod) AS VARCHAR(64))
                ,ResearchPatientId

            FROM Hospfair.HeartRate a

) b
WHERE ResearchPatientId = '{}'
      

) pvt
UNPIVOT (obj FOR pred IN (MeasurementMethod)
) unpiv


