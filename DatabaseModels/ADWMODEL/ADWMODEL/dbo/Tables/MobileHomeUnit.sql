﻿CREATE TABLE [dbo].[MobileHomeUnit] (
    [UnitNbr]                      INT             NOT NULL,
    [PolicyId]                     INT             NOT NULL,
    [PolicyNbr]                    VARCHAR (16)    NOT NULL,
    [UnitAddedDt]                  DATE            NULL,
    [UnitInceptionDt]              DATE            NULL,
    [EQAddDt]                      DATE            NULL,
    [EQRemoveDt]                   DATE            NULL,
    [AddressLine1Desc]             VARCHAR (100)   NULL,
    [AddressLine2Desc]             VARCHAR (100)   NULL,
    [AddressLine3Desc]             VARCHAR (100)   NULL,
    [CityNm]                       CHAR (30)       NULL,
    [LocationCountyNbr]            CHAR (3)        NULL,
    [StateOrProvinceCd]            CHAR (3)        NULL,
    [ZipCd]                        CHAR (9)        NULL,
    [RateClassCd]                  CHAR (1)        NULL,
    [DepreciationInd]              CHAR (1)        NULL,
    [FoundationCd]                 CHAR (1)        NULL,
    [ZoneCd]                       CHAR (2)        NULL,
    [OccupancyCd]                  CHAR (1)        NULL,
    [OccupancyTypeCd]              CHAR (1)        NULL,
    [HeatTypeCd]                   CHAR (1)        NULL,
    [TrailerParkInd]               CHAR (1)        NULL,
    [ManufacturingYearDt]          CHAR (4)        NULL,
    [ConstructionTypeCd]           CHAR (1)        NULL,
    [AnchoringSystemTypeCd]        CHAR (1)        NULL,
    [MobileHomeLengthNbr]          INT             NULL,
    [MobileHomeWidthNbr]           INT             NULL,
    [ExtendedLengthNbr]            INT             NULL,
    [ExtendedWidthNbr]             INT             NULL,
    [MobileHomeMakeNm]             VARCHAR (100)   NULL,
    [MobileHomeSerialNbr]          CHAR (20)       NULL,
    [PurchaseDt]                   DATE            NULL,
    [PurchasePriceAmt]             INT             NULL,
    [LandPurchaceIncludedInd]      CHAR (1)        NULL,
    [LandPriceAmt]                 DECIMAL (10, 2) NULL,
    [LandSizeDesc]                 VARCHAR (255)   NULL,
    [RatingTerritoryCd]            CHAR (2)        NULL,
    [NumberFamiliesCnt]            INT             NULL,
    [DistanceFromHydrantCd]        CHAR (2)        NULL,
    [DistanceFromFireStationCd]    CHAR (2)        NULL,
    [DistanceFromUtilityPoleNbr]   INT             NULL,
    [RPMConditionCd]               CHAR (1)        NULL,
    [IRPMClaimsPct]                DECIMAL (5, 2)  NULL,
    [IRPMPhysicalConditionPct]     DECIMAL (5, 2)  NULL,
    [FireProtectionAreaNm]         VARCHAR (300)   NULL,
    [LegalAddressDesc]             VARCHAR (300)   NULL,
    [ConstructionTypeDesc]         CHAR (50)       NULL,
    [PhysicalCharDebitNbr]         INT             NULL,
    [PhysicalCharDesc]             VARCHAR (255)   NULL,
    [ProtectionClassCd]            VARCHAR (2)     NULL,
    [SprinklerSystemTypeDesc]      VARCHAR (50)    NULL,
    [PrincipalResidenceInsuredInd] CHAR (1)        NULL,
    [PrincipalResidencePolicyNbr]  VARCHAR (16)    NULL,
    [OtherInsuranceInd]            CHAR (1)        NULL,
    [OtherInsuranceDesc]           VARCHAR (255)   NULL,
    [RelocationPlanInd]            CHAR (1)        NULL,
    [RelocationDt]                 DATE            NULL,
    [UndergroundElectricCableInd]  CHAR (1)        NULL,
    [NewWiringInd]                 CHAR (1)        NULL,
    [NewHeatingSystemInd]          CHAR (1)        NULL,
    [AttachedAdditionInd]          CHAR (1)        NULL,
    [AdditionalUnitHUInd]          CHAR (1)        NULL,
    [AdditionalUnitHUDesc]         VARCHAR (255)   NULL,
    [HighestWaterMarkInd]          CHAR (1)        NULL,
    [Within20FtInd]                CHAR (1)        NULL,
    [ParkedCommunityNm]            VARCHAR (255)   NULL,
    [ParkedCummunityOwnedInd]      CHAR (1)        NULL,
    [PreviouslyInsuredInd]         CHAR (1)        NULL,
    [PreviouslyInsuredDesc]        VARCHAR (255)   NULL,
    [SwimmingPoolInd]              CHAR (1)        NULL,
    [FencedOrGatedInd]             CHAR (1)        NULL,
    [DivingBoardInd]               CHAR (1)        NULL,
    [FireExtinguishersInd]         CHAR (1)        NULL,
    [BurglarAlarmInd]              CHAR (1)        NULL,
    [BurglurAlarmTypeDesc]         VARCHAR (255)   NULL,
    [FireAlarmInd]                 CHAR (1)        NULL,
    [FireAlarmTypeDesc]            VARCHAR (255)   NULL,
    [InUnitFPInd]                  CHAR (1)        NULL,
    [FactoryInstalledFPInd]        CHAR (1)        NULL,
    [FPInsertInd]                  CHAR (1)        NULL,
    [SmokeAlarmInd]                CHAR (1)        NULL,
    [DeadboltInd]                  CHAR (1)        NULL,
    [ResidenceAgeNbr]              DECIMAL (5, 2)  NULL,
    [ProtectiveDevicesFctr]        DECIMAL (4, 3)  NULL,
    [PropertyPlusFctr]             DECIMAL (4, 3)  NULL,
    [UpdatedTmstmp]                DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]                CHAR (8)        NOT NULL,
    [LastActionCd]                 CHAR (1)        NOT NULL,
    [SourceSystemCd]               CHAR (2)        NOT NULL,
    CONSTRAINT [PK_MobileHomeUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeUnit_MobileHomePolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[MobileHomePolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnit_01]
    ON [dbo].[MobileHomeUnit]([PolicyId] ASC)
    ON [POLICYCI];

