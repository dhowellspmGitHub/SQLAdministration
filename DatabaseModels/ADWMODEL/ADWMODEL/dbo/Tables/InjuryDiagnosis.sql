CREATE TABLE [dbo].[InjuryDiagnosis] (
    [InjuryDiagnosisId]   INT           NOT NULL,
    [StartDt]             DATE          NULL,
    [EndDt]               DATE          NULL,
    [Comments]            VARCHAR (250) NULL,
    [IsPrimaryInd]        CHAR (1)      NULL,
    [CompensableInd]      CHAR (1)      NULL,
    [ClaimUserCreateTime] DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]  CHAR (8)      NOT NULL,
    [ClaimUserUpdatedId]  CHAR (8)      NOT NULL,
    [ClaimUpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [CurrentRecordInd]    BIT           NOT NULL,
    [RetiredInd]          CHAR (1)      NOT NULL,
    [SourceSystemId]      INT           NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_InjuryDiagnosis] PRIMARY KEY CLUSTERED ([InjuryDiagnosisId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

