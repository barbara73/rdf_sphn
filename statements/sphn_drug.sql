SELECT subj	
	,pred		
	,obj
	
FROM (	SELECT subj
			,ProductCode
            ,ManufacturedDoseForm
			,ActiveIngredient
			,InactiveIngredient

        FROM (
                SELECT DISTINCT
                    subj					=	CONCAT(DrugCodingSystemVersion, '-', Drug, '_', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	Drug

                    ,ManufacturedDoseForm	=	Trim(ManufacturedDoseForm)
                    ,ActiveIngredient		=	ActiveIngredient
                    ,InactiveIngredient		=	InactiveIngredient
                    ,ResearchPatientId

                FROM Hospfair.DrugAdministrationEvent
                WHERE DRUG IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT('ATC-', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	Drug

                    ,ManufacturedDoseForm	=	Trim(ManufacturedDoseForm)
                    ,ActiveIngredient		=	ActiveIngredient
                    ,InactiveIngredient		=	InactiveIngredient
                    ,ResearchPatientId

                FROM Hospfair.DrugAdministrationEvent
                WHERE DRUG IS NULL
                AND (ActiveIngredient IS NOT NULL OR InactiveIngredient IS NOT NULL)

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DrugCodingSystemVersion, '-', Drug, '_', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	Drug

                    ,ManufacturedDoseForm	=	Trim(ManufacturedDoseForm)
                    ,ActiveIngredient		=	ActiveIngredient
                    ,InactiveIngredient		=	InactiveIngredient
                    ,ResearchPatientId

                FROM Hospfair.DrugPrescription
                WHERE DRUG IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT('ATC-', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	Drug

                    ,ManufacturedDoseForm	=	Trim(ManufacturedDoseForm)
                    ,ActiveIngredient		=	ActiveIngredient
                    ,InactiveIngredient		=	InactiveIngredient
                    ,ResearchPatientId

                FROM Hospfair.DrugPrescription
                WHERE DRUG IS NULL AND (ActiveIngredient IS NOT NULL OR InactiveIngredient IS NOT NULL)

) c
WHERE ResearchPatientId = '{}'
) pvt
UNPIVOT (obj FOR pred IN (
                        ProductCode					
						,ManufacturedDoseForm	
						,ActiveIngredient		
						,InactiveIngredient		
                        )
) unpiv
