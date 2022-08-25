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
                    ,ProductCode			=	CAST(Drug AS VARCHAR(64))

                    ,ManufacturedDoseForm	=	CAST(Trim(ManufacturedDoseForm) AS VARCHAR(64))
                    ,ActiveIngredient		=	CAST(CONCAT(ActiveIngredient, '_', ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText, '_', ActiveIngredientGenericName) AS VARCHAR(64))
                    ,InactiveIngredient		=	CAST(CONCAT(InactiveIngredient, '_', InactiveIngredientValue, InactiveIngredientUnitUcum,
                                                    InactiveIngredientComperatorText, '_', InactiveIngredientGenericName) AS VARCHAR(64))
                    ,ResearchPatientId      =   CAST(ResearchPatientId AS VARCHAR(64))

                FROM Hospfair.DrugAdministrationEvent
                WHERE DRUG IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT('ATC-', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	CAST(Drug AS VARCHAR(64))

                    ,ManufacturedDoseForm	=	CAST(Trim(ManufacturedDoseForm) AS VARCHAR(64))
                    ,ActiveIngredient		=	CAST(CONCAT(ActiveIngredient, '_', ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText, '_', ActiveIngredientGenericName) AS VARCHAR(64))
                    ,InactiveIngredient		=	CAST(CONCAT(InactiveIngredient, '_', InactiveIngredientValue, InactiveIngredientUnitUcum,
                                                    InactiveIngredientComperatorText, '_', InactiveIngredientGenericName) AS VARCHAR(64))
                    ,ResearchPatientId      =   CAST(ResearchPatientId AS VARCHAR(64))

                FROM Hospfair.DrugAdministrationEvent
                WHERE DRUG IS NULL
                AND (ActiveIngredient IS NOT NULL OR InactiveIngredient IS NOT NULL)

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DrugCodingSystemVersion, '-', Drug, '_', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	CAST(Drug AS VARCHAR(64))

                    ,ManufacturedDoseForm	=	CAST(Trim(ManufacturedDoseForm) AS VARCHAR(64))
                    ,ActiveIngredient		=	CAST(CONCAT(ActiveIngredient, '_', ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText, '_', ActiveIngredientGenericName) AS VARCHAR(64))
                    ,InactiveIngredient		=	CAST(CONCAT(InactiveIngredient, '_', InactiveIngredientValue, InactiveIngredientUnitUcum,
                                                    InactiveIngredientComperatorText, '_', InactiveIngredientGenericName) AS VARCHAR(64))
                    ,ResearchPatientId      =   CAST(ResearchPatientId AS VARCHAR(64))

                FROM Hospfair.DrugPrescription
                WHERE DRUG IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT('ATC-', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)
                    ,ProductCode			=	CAST(Drug AS VARCHAR(64))

                    ,ManufacturedDoseForm	=	CAST(Trim(ManufacturedDoseForm) AS VARCHAR(64))
                    ,ActiveIngredient		=	CAST(CONCAT(ActiveIngredient, '_', ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText, '_', ActiveIngredientGenericName) AS VARCHAR(64))
                    ,InactiveIngredient		=	CAST(CONCAT(InactiveIngredient, '_', InactiveIngredientValue, InactiveIngredientUnitUcum,
                                                    InactiveIngredientComperatorText, '_', InactiveIngredientGenericName) AS VARCHAR(64))
                    ,ResearchPatientId      =   CAST(ResearchPatientId AS VARCHAR(64))

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
