﻿CREATE TABLE [dbo].[ClaimPolicyEndorsement] (
    [EndorsementId]            INT             NOT NULL,
    [EndorsementEditionYearDt] CHAR (5)        NULL,
    [EndorsementExpiryDt]      DATE            NULL,
    [EndorsementEffectiveDt]   DATE            NULL,
    [AdditionalEndorsementInd] CHAR (1)        NULL,
    [EndorsementDesc]          VARCHAR (255)   NULL,
    [CommentTxt]               VARCHAR (255)   NULL,
    [EndorsementLimitCd]       VARCHAR (20)    NULL,
    [EndorsementGrandTotAmt]   DECIMAL (18, 2) NULL,
    [DeductiblePct]            DECIMAL (5, 2)  NULL,
    [DeductibleAmt]            DECIMAL (18, 2) NULL,
    [UnitLevelEndorsementInd]  CHAR (1)        NULL,
    [ClaimUpdatedTmstmp]       DATETIME2 (7)   NOT NULL,
    [ClaimUserUpdatedId]       CHAR (8)        NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]            CHAR (8)        NOT NULL,
    [LastActionCd]             CHAR (1)        NOT NULL,
    [SourceSystemCd]           CHAR (2)        NOT NULL,
    [FormNbr]                  VARCHAR (64)    NULL,
    [ClaimUserCreateTime]      DATETIME2 (7)   NOT NULL,
    [ClaimUserCreatedId]       CHAR (8)        NOT NULL,
    [CurrentRecordInd]         BIT             NOT NULL,
    [RetiredInd]               CHAR (1)        NOT NULL,
    [SourceSystemId]           INT             NOT NULL,
    CONSTRAINT [PK_ClaimPolicyEndorsement] PRIMARY KEY CLUSTERED ([EndorsementId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

