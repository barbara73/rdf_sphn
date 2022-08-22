SELECT subj
	,pred
	,obj

	
FROM (	SELECT DISTINCT
            subj						=	UniqueId        
            ,patient					=	CAST(ResearchPatientId		AS VARCHAR(64)) 
            ,institute					=	CAST('CHE_108_904_325'		AS VARCHAR(64)) 
			,ReasonToStop				=	CAST(ReasonToStop			AS VARCHAR(64)) 
            ,fall						=	CAST(ResearchCaseId			AS VARCHAR(64)) 
					
            ,AdministrationDrug			=	CASE
												WHEN DRUG IS NOT NULL THEN CAST(CONCAT(DrugCodingSystemVersion, '-', Drug, '_', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)		AS VARCHAR(64))
												ELSE CAST(CONCAT('ATC-', ActiveIngredient, '_', InactiveIngredient, '_',AdministrableDoseForm)		AS VARCHAR(64))
											END
            ,AdministrationDrugQuantity =	CASE
												WHEN DrugQuantity IS NULL THEN NULL
												ELSE CAST(CONCAT(DrugQuantity, DrugQuantityUnitUCUM, DrugQuantityComperatorText)	AS VARCHAR(64))
											END
			,AdministrationDuration		=	CASE
												WHEN DurationValue IS NULL THEN NULL
												ELSE CAST(CONCAT(DurationValue, DurationUnitUCUM, DurationComperatorText)			AS VARCHAR(64)) 
											END
            ,AdministrationStart		=	CAST(CONVERT(NVARCHAR(32), StartDateTime, 126)		AS VARCHAR(64)) 
            ,AdministrationEnd			=	CAST(CONVERT(NVARCHAR(32), EndDateTime, 126)		AS VARCHAR(64)) 
			,AdministrableDoseForm		=	CAST(Trim(AdministrableDoseForm)	AS VARCHAR(64)) 
			,AdministrationTimePattern	=	CAST(Trim(TimePattern)				AS VARCHAR(64))
			,AdministrationRoute		=	CAST(Trim(AdministrationRoute)		AS VARCHAR(64))
			

        FROM Hospfair.DrugAdministrationEvent
		WHERE ResearchPatientId = '{}'
		AND (DRUG is not NULL OR ActiveIngredient IS Not NULL OR InactiveIngredient IS NOT NULL)
		
) pvt
UNPIVOT (obj FOR pred IN (patient						
                        ,institute
                        ,fall
                       ,ReasonToStop				
					   ,AdministrationDrug							
					   ,AdministrationDrugQuantity 		
					   ,AdministrationDuration				
					   ,AdministrationStart		
					   ,AdministrationEnd			
					   ,AdministrableDoseForm		
					   ,AdministrationTimePattern	
					   ,AdministrationRoute		
                        )
) unpiv