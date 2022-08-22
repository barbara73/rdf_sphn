SELECT subj	
	,pred		
	,obj


FROM (SELECT subj
	    ,DoseForm

	  FROM (    SELECT DISTINCT
                    subj			=	Trim(AdministrableDoseForm)
                    ,DoseForm		=	CAST(Trim(AdministrableDoseForm)	AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugAdministrationEvent a

                UNION

                SELECT DISTINCT
                    subj			=	Trim(AdministrableDoseForm)
                    ,DoseForm		=	CAST(Trim(AdministrableDoseForm)	AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugPrescription a

                ) b
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (DoseForm)
) unpiv