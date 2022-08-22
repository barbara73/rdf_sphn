SELECT subj					
		,pred
		,obj

FROM (	SELECT DISTINCT subj			=	[UniqueId]
			  ,institute				=	CAST('CHE_108_904_325'		AS VARCHAR(64))
			  ,patient					=	CAST(a.ResearchPatientId	AS VARCHAR(64))
			  ,fall						=	CAST([ResearchCaseId]		AS VARCHAR(64))
			  ,Height					=	CASE
			                                    WHEN Value IS NULL  THEN NULL
			                                    ELSE CAST(CONCAT([Value], UnitUcum, ComperatorText)	AS VARCHAR(64))
			                                END
			  ,HeightDateTime			=	CAST(CONVERT(NVARCHAR(32),[ObservationDateTime], 126)	AS VARCHAR(64))

		FROM [Hospfair].[BodyHeight] a
		WHERE ResearchPatientId = '{}'
		AND Value IS NOT NULL


) pvt
UNPIVOT (obj FOR pred IN (
						institute
						,patient
						,fall		
						,Height
						,HeightDateTime
						
					)
) unpiv
