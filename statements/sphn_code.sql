SELECT subj	
	,pred		
	,obj


FROM (	SELECT subj
			,Code
            ,CodeDescription
			,CodeVersion
        FROM (

                SELECT DISTINCT
                    subj				=	DataProviderInstitute
                    ,Code				=	CAST('CHE-108.904.325'				AS VARCHAR(64))
                    ,CodeDescription	=	CAST('Universitätsspital Zürich'	AS VARCHAR(64))
                    ,CodeVersion		=	CAST('UID'							AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.Patient

                UNION
                SELECT DISTINCT
                    subj				=	Drug
                    ,Code				=	CAST(Drug	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(DrugName AS VARCHAR(64))
                    ,CodeVersion		=	CAST(DrugCodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugAdministrationEvent a
                WHERE Drug is not NULL

                UNION

                SELECT DISTINCT
                    subj				=	Drug
                    ,Code				=	CAST(Drug	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(DrugName AS VARCHAR(64))
                    ,CodeVersion		=	CAST(DrugCodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.DrugPrescription a
                WHERE Drug is not NULL

                UNION

                SELECT DISTINCT
                    subj				=	CONCAT(CodingSystemVersion, '_', Grade)
                    ,Code				=	CAST(Grade	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(GradeText AS VARCHAR(64))
                    ,CodeVersion		=	CAST(CodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.TumorGrade a
                WHERE Grade is not NULL
                    AND LEFT(CodingSystemVersion, 6) <> 'SNOMED'

                UNION

                SELECT DISTINCT
                    subj				=	CONCAT(CodingSystemVersion, '_', Stage)
                    ,Code				=	CAST(Stage	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(StageText AS VARCHAR(64))
                    ,CodeVersion		=	CAST(CodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.TumorStage a
                WHERE Stage is not NULL
                    AND LEFT(CodingSystemVersion, 6) <> 'SNOMED'

                UNION

                SELECT DISTINCT
                    subj				=	CONCAT(TopographyCodingSystemVersion, '_', Topography)
                    ,Code				=	CAST(Topography	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(TopographyCodeText AS VARCHAR(64))
                    ,CodeVersion		=	CAST(TopographyCodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.ICDODiagnosis a
                WHERE Topography is not NULL

                UNION

                SELECT DISTINCT
                    subj				=	CONCAT(MorphologyCodingSystemVersion, '_', Morphology)
                    ,Code				=	CAST(Morphology	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(MorphologyCodeText AS VARCHAR(64))
                    ,CodeVersion		=	CAST(MorphologyCodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.ICDODiagnosis a
                WHERE Morphology is not NULL

                UNION

                SELECT DISTINCT
                    subj				=	CONCAT(DiagnosisCodingSystemVersion, '_', Diagnosis)
                    ,Code				=	CAST(Diagnosis	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(DiagnosisCodeText AS VARCHAR(64))
                    ,CodeVersion		=	CAST(DiagnosisCodingSystemVersion		AS VARCHAR(64))
                    ,ResearchPatientId

                FROM Hospfair.NursingDiagnosis a
                WHERE Diagnosis is not NULL

                UNION

                SELECT DISTINCT
                    subj				=	UniqueId_LabTest
                    ,Code				=	CAST(LabTest	AS VARCHAR(64))
                    ,CodeDescription	=	CAST(LabTestName AS VARCHAR(64))
                    ,CodeVersion		=	CAST(LabTestCodingSystem	AS VARCHAR(64))
                    ,ResearchPatientId

		        FROM Hospfair.LabResult a
		        WHERE LabTest is not NULL
		            AND LabTestCodingSystem = 'internal'
) c
WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (Code			
						  ,CodeDescription
                         ,CodeVersion
						 )
) unpiv
