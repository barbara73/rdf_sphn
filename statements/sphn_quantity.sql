SELECT subj	
	,pred		
	,obj


FROM (	SELECT DISTINCT
            subj
			,QuantityComparator
			,QuantityValue
			,QuantityCode
			,QuantityUnit
        FROM (

                SELECT DISTINCT
                    subj					=	CONCAT(DATEDIFF(Year,
                                                    cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
                                                    AgeDeterminationDateTime), AgeUnitUCUM, AgeComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN AgeComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN AgeComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN AgeComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN AgeComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN AgeComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(DATEDIFF(Year,
                                                    cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
                                                    AgeDeterminationDateTime)		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(AgeUnitUCUM					AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.FophDiagnosis a

                    LEFT JOIN Hospfair.Patient b
                    ON a.ResearchPatientId = b.ResearchPatientId

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(Quantity, UnitUcum, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(Quantity				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM				AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.Allergy a
                WHERE Quantity is not NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(MeanPressure, MeanUnitUcum, MeanComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN MeanComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN MeanComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN MeanComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN MeanComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN MeanComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(MeanPressure		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL				AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(MeanUnitUCUM		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.BloodPressure a
                WHERE MeanPressure is NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(SystolicPressure, SystolicUnitUcum, SystolicComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN SystolicComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN SystolicComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN SystolicComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN SystolicComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN SystolicComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(SystolicPressure		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(SystolicUnitUCUM		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.BloodPressure a
                WHERE SystolicPressure IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DiastolicPressure, DiastolicUnitUcum, DiastolicComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN DiastolicComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN DiastolicComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN DiastolicComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN DiastolicComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN DiastolicComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(DiastolicPressure		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(DiastolicUnitUCUM		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.BloodPressure a
                WHERE DiastolicPressure IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([Value], UnitUcum, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([Value]				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM				AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[OxygenSaturation] a
                WHERE [Value] IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([Value], UnitUcum, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([Value]				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM				AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[BodyHeight] a
                WHERE [Value] IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([Value], UnitUcum, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([Value]				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM				AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[HeartRate] a
                WHERE [Value] IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([Value], UnitUcum, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([Value]				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM				AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[BodyWeight] a
                WHERE [Value] IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([Value], UnitUcum, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([Value]				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM				AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[BodyTemperature] a
                WHERE [Value] IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DrugQuantity, DrugQuantityUnitUcum, DrugQuantityComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN DrugQuantityComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN DrugQuantityComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN DrugQuantityComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN DrugQuantityComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN DrugQuantityComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(DrugQuantity		    AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(DrugQuantityUnitUcum	AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[DrugAdministrationEvent] a
                WHERE DrugQuantity IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([ActiveIngredientValue], ActiveIngredientUnitUcum, ActiveIngredientComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN ActiveIngredientComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN ActiveIngredientComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN ActiveIngredientComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN ActiveIngredientComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN ActiveIngredientComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([ActiveIngredientValue]		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(ActiveIngredientUnitUcum		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[DrugAdministrationEvent] a
                WHERE ActiveIngredientValue IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DurationValue, DurationUnitUCUM, DurationComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN DurationComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN DurationComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN DurationComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN DurationComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN DurationComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([DurationValue]		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(DurationUnitUcum		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[DrugAdministrationEvent] a
                WHERE DurationValue IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(FrequencyValue, FrequencyUnitUCUM, FrequencyComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN FrequencyComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN FrequencyComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN FrequencyComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN FrequencyComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN FrequencyComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([FrequencyValue]		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(FrequencyUnitUcum		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[DrugPrescription] a
                WHERE FrequencyValue IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(UpperLimit, UpperLimitUnitUCUM, UpperLimitComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN UpperLimitComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN UpperLimitComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN UpperLimitComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN UpperLimitComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN UpperLimitComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([UpperLimit]		    AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UpperLimitUnitUcum		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[LabResult] a
                WHERE UpperLimit IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(LowerLimit, LowerLimitUnitUCUM, LowerLimitComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN LowerLimitComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN LowerLimitComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN LowerLimitComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN LowerLimitComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN LowerLimitComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([LowerLimit]		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL					AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(LowerLimitUnitUcum		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[LabResult] a
                WHERE LowerLimit IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(QuantitativeResultValue, QuantitativeResultUnitUCUM, QuantitativeResultComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN QuantitativeResultComperator	= '='	THEN	CAST('Equal'	AS VARCHAR(64))
                                                    WHEN QuantitativeResultComperator	= '>'	THEN	CAST('GreaterThan'	AS VARCHAR(64))
                                                    WHEN QuantitativeResultComperator	= '<'	THEN	CAST('LessThan'	AS VARCHAR(64))
                                                    WHEN QuantitativeResultComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN QuantitativeResultComperator	= '<='	THEN	CAST('LessThanOrEqual'	AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST([QuantitativeResultValue]		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(QuantitativeResultUnitUcum		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM [Hospfair].[LabResult] a
                WHERE QuantitativeResultValue IS NOT NULL

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DATEDIFF(Year,
                                                    cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
                                                    AgeDeterminationDateTime), AgeUnitUCUM, AgeComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN AgeComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN AgeComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN AgeComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN AgeComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN AgeComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(DATEDIFF(Year,
                                                    cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
                                                    AgeDeterminationDateTime)		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(AgeUnitUCUM					AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.ICDODiagnosis a

                    LEFT JOIN Hospfair.Patient b
                    ON a.ResearchPatientId = b.ResearchPatientId

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(DATEDIFF(Year,
                                                    cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
                                                    AgeDeterminationDateTime), AgeUnitUCUM, AgeComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN AgeComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN AgeComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN AgeComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN AgeComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN AgeComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(DATEDIFF(Year,
                                                    cast(CAST(YearOfBirth as char(4)) + RIGHT('00' + LTRIM(MonthOfBirth),2) + RIGHT('00' + LTRIM(DayOfBirth),2) AS Datetime),
                                                    AgeDeterminationDateTime)		AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(AgeUnitUCUM					AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.NursingDiagnosis a

                    LEFT JOIN Hospfair.Patient b
                    ON a.ResearchPatientId = b.ResearchPatientId

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(FractionsNumber, FractionsNumberUnitUCUM, FractionsNumberComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN FractionsNumberComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN FractionsNumberComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN FractionsNumberComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN FractionsNumberComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN FractionsNumberComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(FractionsNumber				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(FractionsNumberUnitUCUM		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.RadiotherapyProcedure a

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT(RadiationQuantity, RadiationQuantityUnitUCUM, RadiationQuantityComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN RadiationQuantityComperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN RadiationQuantityComperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN RadiationQuantityComperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN RadiationQuantityComperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN RadiationQuantityComperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(RadiationQuantity				AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL							AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(RadiationQuantityUnitUCUM		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.RadiotherapyProcedure a

                UNION

                SELECT DISTINCT
                    subj					=	CONCAT([Value], UnitUCUM, ComperatorText)
                    ,QuantityComparator		=	CASE
                                                    WHEN Comperator	= '='	THEN	CAST('Equal'				AS VARCHAR(64))
                                                    WHEN Comperator	= '>'	THEN	CAST('GreaterThan'			AS VARCHAR(64))
                                                    WHEN Comperator	= '<'	THEN	CAST('LessThan'				AS VARCHAR(64))
                                                    WHEN Comperator	= '>='	THEN	CAST('GreaterThanOrEqual'	AS VARCHAR(64))
                                                    WHEN Comperator	= '<='	THEN	CAST('LessThanOrEqual'		AS VARCHAR(64))
                                                    ELSE NULL
                                                END
                    ,QuantityValue			=	CAST(Value			AS VARCHAR(64))
                    ,QuantityCode			=	CAST(NULL			AS VARCHAR(64))
                    ,QuantityUnit			=	CAST(UnitUCUM		AS VARCHAR(64))
                    ,a.ResearchPatientId

                FROM Hospfair.OxygenSaturation a
                WHERE Value IS NOT NULL


        ) c
WHERE ResearchPatientId = '{}'

		--union here the other quantities like inactive ingredient

) pvt
UNPIVOT (obj FOR pred IN (QuantityComparator
							,QuantityValue
							,QuantityCode
							,QuantityUnit

                        )
) unpiv