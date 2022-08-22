SELECT DISTINCT subj
    ,pred
    ,obj

FROM (  SELECT DISTINCT
                subj					=	a.ResearchPatientId
				,ResearchPatientId		=	CAST(a.ResearchPatientId AS VARCHAR(64))
				,institute				=	CAST(DataProviderInstitute AS VARCHAR(64))

        FROM Hospfair.Patient a
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (ResearchPatientID
						    ,institute
							)
) unpiv