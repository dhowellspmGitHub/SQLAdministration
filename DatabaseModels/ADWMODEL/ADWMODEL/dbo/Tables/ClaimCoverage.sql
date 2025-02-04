﻿CREATE TABLE [dbo].[ClaimCoverage] (
    [ClaimCoverageId]             INT             NOT NULL,
    [CoverageTypeId]              INT             NOT NULL,
    [CoverageBasisId]             INT             NULL,
    [NoFaultOptionId]             INT             NULL,
    [CoverageSubTypeId]           INT             NOT NULL,
    [NonMedicalAggregateLimitAmt] DECIMAL (18, 2) NULL,
    [CoverageLimitCd]             VARCHAR (3)     NULL,
    [EffectiveDt]                 DATE            NULL,
    [ExposureLimitAmt]            DECIMAL (18, 2) NULL,
    [IncidentLimitAmt]            DECIMAL (18, 2) NULL,
    [ReplaceAggLimitAmt]          DECIMAL (18, 2) NULL,
    [NoteDesc]                    VARCHAR (255)   NULL,
    [PersonAggLimitAmt]           DECIMAL (18, 2) NULL,
    [CoverageDeductibleCd]        CHAR (10)       NULL,
    [HomeCovDLimitPct]            VARCHAR (3)     NULL,
    [CoinsuranceFctr]             DECIMAL (10)    NULL,
    [ExpirationDt]                DATE            NULL,
    [DeductibleAmt]               DECIMAL (18, 2) NULL,
    [UpdatedTmstmp]               DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]               CHAR (8)        NOT NULL,
    [LastActionCd]                CHAR (1)        NOT NULL,
    [SourceSystemCd]              CHAR (2)        NOT NULL,
    [SourceSystemId]              INT             NOT NULL,
    [ClaimUserCreateTime]         DATETIME2 (7)   NOT NULL,
    [ClaimUserCreatedId]          CHAR (8)        NOT NULL,
    [ClaimUserUpdatedId]          CHAR (8)        NOT NULL,
    [ClaimUpdatedTmstmp]          DATETIME2 (7)   NOT NULL,
    [CurrentRecordInd]            BIT             NOT NULL,
    [RetiredInd]                  CHAR (1)        NOT NULL,
    CONSTRAINT [PK_ClaimCoverage] PRIMARY KEY CLUSTERED ([ClaimCoverageId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimCoverage_ClaimCodeLookup_01] FOREIGN KEY ([CoverageBasisId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_ClaimCoverage_ClaimCodeLookup_02] FOREIGN KEY ([NoFaultOptionId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_ClaimCoverage_ClaimCodeLookup_03] FOREIGN KEY ([CoverageSubTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_ClaimCoverage_ClaimCodeLookup_04] FOREIGN KEY ([CoverageTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

