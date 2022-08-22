SELECT subj
	,pred
	,obj

FROM (	SELECT DISTINCT
             subj						=	UniqueId        
            ,patient					=	CAST(ResearchPatientId		AS VARCHAR(64)) 
            ,institute					=	CAST('CHE_108_904_325'		AS VARCHAR(64)) 
			,fall						=	CAST(ResearchCaseId			AS VARCHAR(64)) 

            ,BiosampleCollectionDateTime	=	CAST(CONVERT(NVARCHAR(64), BiosampleCollectionDateTime, 126)	AS VARCHAR(64))
            ,BiosampleBodySite				=	CASE
													WHEN BodySite IS NULL	THEN NULL
													ELSE CAST(CONCAT(Trim(BodySite),'_', Trim(Laterality))		AS VARCHAR(64))
												END
            ,MaterialTypeLiquid				=   CAST(Trim(MaterialTypeLiquid)		AS VARCHAR(64))
			,StorageContainer				=	CAST(StorageContainer				AS VARCHAR(64))
			,PrimaryContainer				=	CAST(PrimaryContainerType			AS VARCHAR(64))
			,FixationType					=	CAST(FixationType					AS VARCHAR(64))
		
		FROM Hospfair.LabResult
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient						
                        ,institute
                        ,fall
                        ,BiosampleCollectionDateTime
						,BiosampleBodySite			
						,MaterialTypeLiquid			
						,StorageContainer			
						,PrimaryContainer			
						,FixationType				

                        )
) unpiv
