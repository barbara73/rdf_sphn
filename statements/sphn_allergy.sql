SELECT subj	
	,pred		
	,obj

FROM (	SELECT DISTINCT
            subj				=	UniqueId
			,patient			=	CAST(ResearchPatientId AS VARCHAR(64))
			,institute			=	CAST('CHE_108_904_325'		AS VARCHAR(64)) 
            ,AllergySubstance	=	CAST(CONCAT(Substance, '_', Quantity, UnitUcum, ComperatorText, '_', SubstanceGenericName) AS VARCHAR(64))
			,SubstanceCategory	=	CAST(SubstanceCategory		AS VARCHAR(64))
			,Severity			=	CAST(Severity				AS VARCHAR(64))
			,ReactionType		=	CAST(ReactionType			AS VARCHAR(64))
			,VerificationStatus =	CAST(VerificationStatus		AS VARCHAR(64))

             
        FROM Hospfair.Allergy a
		WHERE ResearchPatientId = '{}'


) pvt
UNPIVOT (obj FOR pred IN (patient
							,institute
							,AllergySubstance
							,SubstanceCategory
							,Severity
							,ReactionType
							,VerificationStatus

                        )
) unpiv
