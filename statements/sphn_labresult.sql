SELECT subj
	,pred
	,obj

FROM (	SELECT DISTINCT
            subj						=	CONCAT(UniqueId, UniqueId_LabTest, QuantitativeResultValue, QuantitativeResultUnitUCUM)
            ,patient					=	CAST(ResearchPatientId			AS VARCHAR(64)) 
            ,institute					=	CAST('CHE_108_904_325'			AS VARCHAR(64)) 
			,fall						=	CAST(ResearchCaseId				AS VARCHAR(64)) 
			,Comment					=	CAST(Comment					AS VARCHAR(64))
			,QuantitativeResult			=	CASE
			                                    WHEN QualitativeResultValue IS NULL     THEN NULL
			                                    ELSE CAST(CONCAT(QuantitativeResultValue, QuantitativeResultUnitUCUM, QuantitativeResultComperatorText)	AS VARCHAR(64))
			                                END
			,QuantitativeResultCode		=	CAST(QuantitativeResult			AS VARCHAR(64))
			,QualitativeResult			=	CAST(QualitativeResultValue		AS VARCHAR(64))
            ,UniqueIDReferenceRange		=	CASE
												WHEN UniqueId_ReferenceRange IS NULL                THEN NULL
												WHEN UpperLimit IS NULL AND LowerLimit IS NULL      THEN NULL
												ELSE CAST(CONCAT(UniqueId_ReferenceRange, '_', QuantitativeResultUnitUCUM)	AS VARCHAR(64))   
											END
            ,LabResultReportDateTime    =	CAST(CONVERT(NVARCHAR(32), ReportDateTime, 126) AS VARCHAR(64)) 
            ,UniqueIDLabTest			=	CAST(UniqueId_LabTest			AS VARCHAR(64))
            ,BiosampleId				=	CAST(UniqueId					AS VARCHAR(64))  --check

        FROM Hospfair.LabResult
		WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient						
                        ,institute
                        ,fall
                        ,Comment				
						,QuantitativeResult		
						,QuantitativeResultCode	
						,QualitativeResult		
						,UniqueIDReferenceRange	
						,LabResultReportDateTime
						,UniqueIDLabTest		
						,BiosampleId			
                        )
) unpiv
