SELECT DISTINCT subj
    ,pred
    ,obj

FROM (  SELECT DISTINCT
            subj					=	a.ResearchPatientId							
            ,patient				=	CAST(a.ResearchPatientId	AS VARCHAR(64))		
            ,AdministrativeGender	=	CAST(AdministrativeGender	AS VARCHAR(64))

		FROM Hospfair.Patient a
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (
						 patient
						 ,AdministrativeGender
                         )
) unpiv