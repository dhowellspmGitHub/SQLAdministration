﻿CREATE TABLE [dbo].[FireQuoteUnit] (
    [QuoteNbr]                    VARCHAR (16)    NOT NULL,
    [UnitNbr]                     INT             NOT NULL,
    [FireClassCd]                 CHAR (5)        NULL,
    [WindClassCd]                 CHAR (3)        NULL,
    [ProtectionClassCd]           VARCHAR (2)     NULL,
    [ConstructionTypeCd]          CHAR (1)        NULL,
    [ConstructionYearDt]          CHAR (4)        NULL,
    [OccupancyTypeCd]             CHAR (1)        NULL,
    [NumberFamiliesCnt]           INT             NULL,
    [RatingTerritoryCd]           CHAR (2)        NULL,
    [DistanceFromHydrantCd]       CHAR (2)        NULL,
    [DistanceFromFireStationCd]   CHAR (2)        NULL,
    [FireProtectionAreaNm]        VARCHAR (300)   NULL,
    [PrimaryDwellingIndicator]    CHAR (1)        NULL,
    [UnitDesc]                    VARCHAR (255)   NULL,
    [LocationCountyNbr]           CHAR (3)        NULL,
    [PurchaseDt]                  DATE            NULL,
    [PurchasePriceAmt]            DECIMAL (10, 2) NULL,
    [ResidenceTypeDesc]           VARCHAR (50)    NULL,
    [DwellingStatusDesc]          VARCHAR (50)    NULL,
    [AdditioinalDesc]             VARCHAR (255)   NULL,
    [PrimaryHeatingDesc]          VARCHAR (50)    NULL,
    [HeatingUpgradeYearDt]        CHAR (4)        NULL,
    [PlumbingUpgradeYearDt]       CHAR (4)        NULL,
    [WiriingUpgradeYearDt]        CHAR (4)        NULL,
    [SprinklerSystemTypeDesc]     VARCHAR (50)    NULL,
    [DwellingUsageDesc]           CHAR (50)       NULL,
    [LengthNbr]                   DECIMAL (5)     NULL,
    [WidthNbr]                    DECIMAL (5)     NULL,
    [FireAlarmTypeDesc]           VARCHAR (255)   NULL,
    [FireAlarmInd]                CHAR (1)        NULL,
    [SmokeAlarmInd]               CHAR (1)        NULL,
    [ContentsLocatedDesc]         VARCHAR (255)   NULL,
    [GarageTypeDesc]              VARCHAR (255)   NULL,
    [SwimmingPoolTypeDesc]        VARCHAR (255)   NULL,
    [OutbuildingOccupanceDesc]    VARCHAR (255)   NULL,
    [ConditionChargeDesc]         VARCHAR (255)   NULL,
    [GarageOccupiedDesc]          VARCHAR (255)   NULL,
    [TownhouseOccupiedDesc]       VARCHAR (255)   NULL,
    [AddressLine1Desc]            VARCHAR (100)   NULL,
    [AddressLine2Desc]            VARCHAR (100)   NULL,
    [AddressLine3Desc]            VARCHAR (100)   NULL,
    [CityNm]                      CHAR (30)       NULL,
    [StateOrProvinceCd]           CHAR (3)        NULL,
    [ZipCd]                       CHAR (9)        NULL,
    [OtherInsuranceInd]           CHAR (1)        NULL,
    [OtherInsuranceDesc]          VARCHAR (255)   NULL,
    [MultipleStructureInd]        CHAR (1)        NULL,
    [SwimmingPoolInd]             CHAR (1)        NULL,
    [FencedOrGatedInd]            CHAR (1)        NULL,
    [DivingBoardInd]              CHAR (1)        NULL,
    [DeadboltInd]                 CHAR (1)        NULL,
    [PreviouslyInsuredInd]        CHAR (1)        NULL,
    [PreviouslyInsuredDesc]       VARCHAR (255)   NULL,
    [PrincipalResidenceInd]       CHAR (1)        NULL,
    [PrincipalResidencePolicyNbr] VARCHAR (16)    NULL,
    [AssociatedItemDesc]          VARCHAR (255)   NULL,
    [TypeOfStructureDesc]         VARCHAR (255)   NULL,
    [MineSubsidenceCoverageCd]    CHAR (1)        NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]               CHAR (8)        NOT NULL,
    [LastActionCd]                CHAR (1)        NOT NULL,
    [SourceSystemCd]              CHAR (2)        NOT NULL,
    CONSTRAINT [PK_FireQuoteUnit] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnit_FireQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FireQuote] ([QuoteNbr])
) ON [POLICYCD];

