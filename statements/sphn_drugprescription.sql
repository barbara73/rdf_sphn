SELECT subj
	,pred
	,obj

	
FROM (	SELECT DISTINCT
            subj								=	UniqueId        
            ,patient							=	CAST(ResearchPatientId		AS VARCHAR(64)) 
            ,institute							=	CAST('CHE_108_904_325'		AS VARCHAR(64)) 
            ,fall								=	CAST(ResearchCaseId			AS VARCHAR(64)) 
					
            ,PrescriptionDrug					=	CASE
														WHEN DRUG IS NOT NULL THEN CAST(CONCAT(DrugCodingSystemVersion, '-', Drug, '_', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)		AS VARCHAR(64))
														ELSE CAST(CONCAT('ATC-', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)		AS VARCHAR(64))
													END
            ,PrescriptionDrugQuantity			=	CASE
														WHEN DrugQuantity IS NULL THEN NULL
														ELSE CAST(CONCAT(DrugQuantity, DrugQuantityUnitUCUM, DrugQuantityComperatorText)	AS VARCHAR(64))
													END
			,PrescriptionFrequency				=	CASE
														WHEN FrequencyValue IS NULL THEN NULL
														ELSE CAST(CONCAT(FrequencyValue, FrequencyUnitUCUM, FrequencyComperatorText)	AS VARCHAR(64)) 
													END
            ,FirstAdministrationDateTime		=	CAST(CONVERT(NVARCHAR(32), FirstAdministrationDateTime, 126)				AS VARCHAR(64)) 
            ,LastAdministrationDateTime			=	CAST(CONVERT(NVARCHAR(32), [LastAdministrationDateTime	datetime2], 126)	AS VARCHAR(64)) 
			,PrescriptionIntent					=	CAST(Trim(Intent)						AS VARCHAR(64))			
			,PrescriptionAdministrableDoseForm	=	CAST(Trim(AdministrableDoseForm)		AS VARCHAR(64)) 
			,PrescriptionTimePattern			=	CAST(Trim(TimePattern)					AS VARCHAR(64))
			,PrescriptionAdministrationRoute	=	CAST(Trim(AdministrationRoute)			AS VARCHAR(64))
			,IndikationToStart					=	CAST(Trim(IndicationToStartDiagnosis)	AS VARCHAR(64))
			

        FROM Hospfair.DrugPrescription
		WHERE ResearchPatientId = '{}'
		AND (DRUG is not NULL OR ActiveIngredient IS Not NULL OR InactiveIngredient IS NOT NULL)
		
) pvt
UNPIVOT (obj FOR pred IN (patient						
                        ,institute
                        ,fall
						,PrescriptionDrug							
						,PrescriptionDrugQuantity								
						,PrescriptionFrequency										
						,FirstAdministrationDateTime		
						,LastAdministrationDateTime			
						,PrescriptionIntent					
						,PrescriptionAdministrableDoseForm	
						,PrescriptionTimePattern			
						,PrescriptionAdministrationRoute	
						,IndikationToStart					

                        )
) unpiv
