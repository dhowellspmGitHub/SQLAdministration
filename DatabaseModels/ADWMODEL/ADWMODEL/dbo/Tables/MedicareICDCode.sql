CREATE TABLE [dbo].[MedicareICDCode] (
    [MedicareICDCodeId]   INT           NOT NULL,
    [ICDCd]               VARCHAR (8)   NULL,
    [ICDCdAvailabilityDt] DATE          NULL,
    [ICDCdBodySystemId]   INT           NULL,
    [ICDCdDesc]           VARCHAR (250) NULL,
    [ICDCdExpiryDt]       DATE          NULL,
    [ICDChronicInd]       CHAR (1)      NULL,
    [ClaimUserCreateTime] DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]  CHAR (8)      NOT NULL,
    [ClaimUserUpdatedId]  CHAR (8)      NOT NULL,
    [ClaimUpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [RetiredInd]          CHAR (1)      NOT NULL,
    [CurrentRecordInd]    BIT           NOT NULL,
    [SourceSystemId]      INT           NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MedicareICDCode] PRIMARY KEY CLUSTERED ([MedicareICDCodeId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_MedicareICDCode_ClaimCodeLookup_01] FOREIGN KEY ([ICDCdBodySystemId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

