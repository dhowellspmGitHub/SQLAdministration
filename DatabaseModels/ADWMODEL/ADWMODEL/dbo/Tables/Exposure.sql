﻿CREATE TABLE [dbo].[Exposure] (
    [ExposureId]                 INT             NOT NULL,
    [IncidentCodeId]             INT             NULL,
    [ExposureStateId]            INT             NULL,
    [SubrogationStatusId]        INT             NULL,
    [SalvageStatusId]            INT             NULL,
    [CoverageSubTypeId]          INT             NULL,
    [ReplacementCostID]          INT             NULL,
    [ClaimantTypeId]             INT             NULL,
    [ExposureTypeId]             INT             NULL,
    [ExposureReopenedReasonId]   INT             NULL,
    [ISOStatusID]                INT             NULL,
    [ClosedOutcomeID]            INT             NULL,
    [LossPartyTypeId]            INT             NULL,
    [AlternateContactId]         INT             NULL,
    [ClaimantId]                 INT             NULL,
    [CashUnitNbr]                CHAR (3)        NULL,
    [ClaimCodeLookupId]          INT             NULL,
    [StateJurisdictionCd]        CHAR (3)        NULL,
    [SubrogationCompleteDt]      DATE            NULL,
    [SalvageCompleteDt]          DATE            NULL,
    [SalvageTargetAmt]           DECIMAL (18, 2) NULL,
    [ExposureNbr]                CHAR (10)       NOT NULL,
    [ExposureAssignmentDt]       DATE            NULL,
    [ISOKnownInd]                CHAR (1)        NULL,
    [SubrogationTargetAmt]       DECIMAL (18, 2) NULL,
    [StackableCoverageApplyInd]  CHAR (1)        NULL,
    [ExposureClosedDt]           DATE            NULL,
    [ExposureReopenedDt]         DATE            NULL,
    [LitigationSuitCnt]          INT             NULL,
    [OwnerRetainedInd]           CHAR (1)        NULL,
    [SalvageVehicleEstimatedAmt] DECIMAL (18, 2) NULL,
    [FactoredReserveInd]         CHAR (1)        NULL,
    [ClaimUserCreateTime]        DATETIME2 (7)   NOT NULL,
    [ClaimUserCreatedId]         CHAR (8)        NOT NULL,
    [ClaimUserUpdatedId]         CHAR (8)        NOT NULL,
    [ClaimUpdatedTmstmp]         DATETIME2 (7)   NOT NULL,
    [KFBConversionDt]            DATETIME2 (7)   NULL,
    [AnnuityTermDt]              DATE            NULL,
    [SalvageStartDt]             DATE            NULL,
    [SubrogationStartDt]         DATE            NULL,
    [CurrentRecordInd]           BIT             NOT NULL,
    [RetiredInd]                 CHAR (1)        NOT NULL,
    [SourceSystemId]             INT             NOT NULL,
    [ThirdPartyInd]              CHAR (1)        NULL,
    [UpdatedTmstmp]              DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]              CHAR (8)        NOT NULL,
    [LastActionCd]               CHAR (1)        NOT NULL,
    [SourceSystemCd]             CHAR (2)        NOT NULL,
    CONSTRAINT [PK_Exposure] PRIMARY KEY CLUSTERED ([ExposureId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_01] FOREIGN KEY ([ExposureReopenedReasonId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_02] FOREIGN KEY ([ClosedOutcomeID]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_03] FOREIGN KEY ([LossPartyTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_04] FOREIGN KEY ([ISOStatusID]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_05] FOREIGN KEY ([CoverageSubTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_06] FOREIGN KEY ([IncidentCodeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_07] FOREIGN KEY ([ExposureStateId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_08] FOREIGN KEY ([SubrogationStatusId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_09] FOREIGN KEY ([SalvageStatusId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_10] FOREIGN KEY ([ClaimantTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_11] FOREIGN KEY ([ExposureTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_ClaimCodeLookup_12] FOREIGN KEY ([ReplacementCostID]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_Exposure_Party_01] FOREIGN KEY ([ClaimantId]) REFERENCES [dbo].[Party] ([PartyId]),
    CONSTRAINT [FK_Exposure_Party_02] FOREIGN KEY ([AlternateContactId]) REFERENCES [dbo].[Party] ([PartyId])
) ON [CLAIMSCD];


GO
CREATE NONCLUSTERED INDEX [IX_Exposure_01]
    ON [dbo].[Exposure]([ExposureNbr] ASC, [ExposureStateId] ASC)
    ON [CLAIMSCI];

