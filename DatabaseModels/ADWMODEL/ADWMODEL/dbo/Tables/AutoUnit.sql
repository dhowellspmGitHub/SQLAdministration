﻿CREATE TABLE [dbo].[AutoUnit] (
    [PolicyId]                           INT            NOT NULL,
    [UnitNbr]                            INT            NOT NULL,
    [PolicyNbr]                          VARCHAR (16)   NOT NULL,
    [SublineBusinessTypeCd]              CHAR (1)       NOT NULL,
    [VINNbr]                             CHAR (17)      NULL,
    [VehicleModelNm]                     VARCHAR (40)   NULL,
    [VehicleBodyCd]                      CHAR (10)      NULL,
    [VehicleMakeCd]                      CHAR (4)       NULL,
    [VehicleTypeCd]                      CHAR (1)       NULL,
    [VehicleTypeDesc]                    VARCHAR (200)  NULL,
    [VehicleYearDt]                      CHAR (4)       NULL,
    [VehicleActualCostAmt]               DECIMAL (9, 2) NULL,
    [UnitInceptionDt]                    DATE           NULL,
    [UnitAddedDt]                        DATE           NULL,
    [UnitPurchaseDt]                     DATE           NULL,
    [LocationCountyNbr]                  CHAR (3)       NULL,
    [LocationZipCd]                      CHAR (9)       NULL,
    [LocationDescTxt]                    VARCHAR (30)   NULL,
    [AntiTheftDeviceCd]                  CHAR (2)       NULL,
    [AntiTheftDeviceDesc]                VARCHAR (200)  NULL,
    [AntiLockBrakesInd]                  CHAR (1)       NULL,
    [AlteredVehicleInd]                  CHAR (1)       NULL,
    [PassiveRestraintCd]                 CHAR (1)       NULL,
    [OwnOrLeaseCd]                       CHAR (2)       NULL,
    [OwnOrLeaseDesc]                     VARCHAR (200)  NULL,
    [SpecialVehicleCd]                   CHAR (1)       NULL,
    [SpecialVehicleDesc]                 VARCHAR (200)  NULL,
    [PrimaryUseCd]                       CHAR (2)       NULL,
    [DeliveryInd]                        CHAR (1)       NULL,
    [PIP_MEDSymbolCd]                    CHAR (3)       NULL,
    [RadiusOperateMilesCnt]              CHAR (5)       NULL,
    [UnitConversionCd]                   CHAR (1)       NULL,
    [UnitConversionDesc]                 VARCHAR (200)  NULL,
    [SystemConversionCd]                 CHAR (2)       NULL,
    [VINVerifyCd]                        CHAR (1)       NULL,
    [AnnualMilesAmt]                     INT            NULL,
    [DepartmentofMotorTransportationInd] CHAR (1)       NULL,
    [AgedPointTotalCnt]                  CHAR (2)       NULL,
    [MajorViolationCnt]                  INT            NULL,
    [TotalMiscellaneousEquipmentAmt]     DECIMAL (9, 2) NULL,
    [CarpoolRiderCnt]                    CHAR (1)       NULL,
    [CarpoolUseageInd]                   CHAR (1)       NULL,
    [CoverageChangedDt]                  DATE           NULL,
    [TransactionDt]                      DATE           NULL,
    [PriorProcessingDt]                  DATE           NULL,
    [UnitRateEditionDt]                  DATE           NULL,
    [AssignedUseCd]                      CHAR (1)       NULL,
    [ExperienceRateCreditCd]             CHAR (1)       NULL,
    [LiabilityBIPDSymbolCd]              CHAR (3)       NULL,
    [LiabilitySurchargeInd]              CHAR (1)       NULL,
    [VehicleUseCd]                       CHAR (1)       NULL,
    [VehicleUseDesc]                     VARCHAR (200)  NULL,
    [NoFaultOptionCd]                    CHAR (1)       NULL,
    [RatedUseCd]                         CHAR (1)       NULL,
    [UnitRatePlanCd]                     CHAR (2)       NULL,
    [VehicleBaseSymbolCd]                CHAR (3)       NULL,
    [VehicleSymbolCd]                    CHAR (3)       NULL,
    [AssignOverrideDriverInd]            CHAR (1)       NULL,
    [RateAgeSetCd]                       CHAR (1)       NULL,
    [RateLevelCd]                        CHAR (1)       NULL,
    [TerritoryCd]                        CHAR (3)       NULL,
    [AssignedDriverNbr]                  CHAR (3)       NULL,
    [ClassRiskCd]                        CHAR (7)       NULL,
    [ClassRiskAnnualMilesCd]             CHAR (1)       NULL,
    [ClassRiskDailyMilesCd]              CHAR (1)       NULL,
    [ClassRiskDriverClassCd]             CHAR (2)       NULL,
    [ClassRiskNbrofPassengersCd]         CHAR (1)       NULL,
    [ClassRiskVehicleRadiusCd]           CHAR (1)       NULL,
    [ClassRiskVehicleWeightCd]           CHAR (1)       NULL,
    [ClassRiskYouthfulDriverDiscountCd]  CHAR (1)       NULL,
    [CollisionSymbolCd]                  CHAR (3)       NULL,
    [CollisionRatingSymbolCd]            CHAR (3)       NULL,
    [ComprehensiveSymbolCd]              CHAR (3)       NULL,
    [ComprehensiveRatingSymbolCd]        CHAR (3)       NULL,
    [BIRatingSymbolCd]                   CHAR (2)       NULL,
    [PDRatingSymbolCd]                   CHAR (2)       NULL,
    [PIPRatingSymbolCd]                  CHAR (2)       NULL,
    [MedPayRatingSymbolCd]               CHAR (2)       NULL,
    [PoorMechanicalConditionInd]         CHAR (1)       NULL,
    [PoorMechanicalConditionDesc]        VARCHAR (255)  NULL,
    [DifferentTitleHolderInd]            CHAR (1)       NULL,
    [TitleHolderNm]                      VARCHAR (255)  NULL,
    [EFormRequiredInd]                   CHAR (1)       NULL,
    [DMTExpirationDt]                    DATE           NULL,
    [VehicleHireInd]                     CHAR (1)       NULL,
    [SemiorTractorPulledInd]             CHAR (1)       NULL,
    [GoodsHauledDesc]                    VARCHAR (255)  NULL,
    [HazardousRoadInd]                   CHAR (1)       NULL,
    [CongestedAreaDrivenInd]             CHAR (1)       NULL,
    [MinorDamageInd]                     CHAR (1)       NULL,
    [MinorDamageDesc]                    VARCHAR (255)  NULL,
    [AlterationTypeCd]                   VARCHAR (50)   NULL,
    [AlterationDesc]                     VARCHAR (255)  NULL,
    [NumberOfPassangersRangeNbr]         CHAR (10)      NULL,
    [PassiveRestraintDesc]               VARCHAR (255)  NULL,
    [FreightorDeliveryDesc]              VARCHAR (255)  NULL,
    [ResidentParkingDesc]                VARCHAR (255)  NULL,
    [VehicleWeightRangeNumber]           VARCHAR (50)   NULL,
    [AxleTypeDesc]                       VARCHAR (255)  NULL,
    [NewCostAmt]                         DECIMAL (9, 2) NULL,
    [LongestTripDestinationDesc]         VARCHAR (255)  NULL,
    [MilesNbr]                           DECIMAL (5)    NULL,
    [BedTypeDesc]                        VARCHAR (255)  NULL,
    [BedValueLimitAmt]                   DECIMAL (9)    NULL,
    [ExperinceRateCd]                    CHAR (1)       NULL,
    [ExperienceRateDt]                   DATE           NULL,
    [CycleTypeDesc]                      VARCHAR (20)   NULL,
    [EngineSizeNbr]                      VARCHAR (10)   NULL,
    [VehicleMakeDesc]                    VARCHAR (22)   NULL,
    [VehicleBodyDesc]                    VARCHAR (55)   NULL,
    [DriveRightMobileInd]                CHAR (1)       NULL,
    [SourceSystemId]                     INT            NOT NULL,
    [UpdatedTmstmp]                      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                      CHAR (8)       NOT NULL,
    [LastActionCd]                       CHAR (1)       NOT NULL,
    [SourceSystemCd]                     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnit_AutoPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[AutoPolicy] ([PolicyId])
) ON [POLICYCD];

