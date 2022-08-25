SELECT subj
	,pred
	,obj


FROM (	SELECT
            subj
			,patient
            ,institute
			,fall
			,LabTest
		FROM (  SELECT DISTINCT
                     subj						=	UniqueId_LabTest
                    ,patient					=	CAST(ResearchPatientId		    AS VARCHAR(64))
                    ,institute					=	CAST('CHE_108_904_325'		    AS VARCHAR(64))
                    ,fall						=	CAST(ResearchCaseId			    AS VARCHAR(64))
                    ,LabTest					=	CAST(CONCAT('loinc:', LabTest)	AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.LabResult
                WHERE LabTest is not NULL
                    AND LabTestCodingSystem = 'LOINC'

                UNION

                SELECT DISTINCT
                     subj						=	UniqueId_LabTest
                    ,patient					=	CAST(ResearchPatientId		AS VARCHAR(64))
                    ,institute					=	CAST('CHE_108_904_325'		AS VARCHAR(64))
                    ,fall						=	CAST(ResearchCaseId			AS VARCHAR(64))
                    ,LabTest					=	CAST(LabTest				AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.LabResult
                WHERE LabTest is not NULL
                    AND LabTestCodingSystem = 'internal'

) c
WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (patient
						  ,institute	
						  ,fall		
							,LabTest	
							)

) unpiv
