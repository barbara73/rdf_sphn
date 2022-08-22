SELECT subj	
	,pred		
	,obj

FROM (	SELECT
            subj
            ,Substance
			,SubstanceQuantity
			,SubstanceGenericName

		FROM (

                SELECT DISTINCT
                    subj					=	CONCAT(Substance, '_', Quantity, UnitUcum, ComperatorText, '_', SubstanceGenericName)
                    ,Substance				=	CAST(Concat('atc:', Substance)					AS VARCHAR(64))
                    ,SubstanceQuantity		=	CAST(CONCAT(Quantity, UnitUcum, ComperatorText) AS VARCHAR(64))
                    ,SubstanceGenericName	=	CAST(SubstanceGenericName						AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.Allergy a
                WHERE Substance IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(ActiveIngredient, '_', ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText, '_', ActiveIngredientGenericName)

                    ,Substance				=	CAST(Concat('atc:', ActiveIngredient)					AS VARCHAR(64))
                    ,SubstanceQuantity		=	CAST(CONCAT(ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText)						AS VARCHAR(64))
                    ,SubstanceGenericName	=	CAST(ActiveIngredientGenericName						AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugAdministrationEvent a
                WHERE ActiveIngredient is NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(InactiveIngredient, '_', InactiveIngredientValue, InactiveIngredientUnitUcum,
                                                    InactiveIngredientComperatorText, '_', InactiveIngredientGenericName)

                    ,Substance				=	CAST(Concat('atc:', InactiveIngredient)					AS VARCHAR(64))
                    ,SubstanceQuantity		=	CAST(CONCAT(InactiveIngredientValue, InactiveIngredientUnitUcum,
                                                    InactiveIngredientComperatorText)						AS VARCHAR(64))
                    ,SubstanceGenericName	=	CAST(InactiveIngredientGenericName						AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugAdministrationEvent a
                WHERE InactiveIngredient IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(ActiveIngredient, '_', ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                    ActiveIngredientComperatorText, '_', ActiveIngredientGenericName)

                    ,Substance				=	CAST(Concat('atc:', ActiveIngredient)					AS VARCHAR(64))
                    ,SubstanceQuantity		=	CASE
                                                    WHEN ActiveIngredientValue IS NULL      THEN NULL
                                                    ELSE CAST(CONCAT(ActiveIngredientValue, ActiveIngredientUnitUcum,
                                                        ActiveIngredientComperatorText)					AS VARCHAR(64))
                                                END
                    ,SubstanceGenericName	=	CAST(ActiveIngredientGenericName						AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugPrescription a
                WHERE ActiveIngredient IS NOT NULL

		--union inactive in
) b
WHERE ResearchPatientId = '{}'
) pvt
UNPIVOT (obj FOR pred IN (Substance
							,SubstanceQuantity
							,SubstanceGenericName

                        )
) unpiv
