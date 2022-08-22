SELECT subj					
    ,pred
    ,obj

FROM (	SELECT DISTINCT subj			=		[ResearchCaseId]
			  ,institute				=		CAST('CHE_108_904_325'		                        AS VARCHAR(64))
			  ,ResearchCaseId			=		CAST([ResearchCaseId]		                        AS VARCHAR(64))
			  ,DateAdmission			=		CAST(CONVERT(NVARCHAR(32),[DateAdmission], 126)		AS VARCHAR(64))
			  ,patient					=		CAST(a.ResearchPatientId	                        AS VARCHAR(64))
			  ,DateDischarge			=		CAST(CONVERT(NVARCHAR(32),[DateDischarge], 126)		AS VARCHAR(64))
			  ,CareHandling				=		CAST(Trim(' ' FROM CareHandlingType)	            AS VARCHAR(64))

		  FROM [RDSC_HOSPFAIR].[Hospfair].[AdministrativeCase] a
		  WHERE ResearchPatientId = '{}'

) pvt
UNPIVOT (obj FOR pred IN (institute
                          ,ResearchCaseId
                          ,patient
                          ,DateAdmission
                          ,DateDischarge
                          ,CareHandling
                         )
) unpiv