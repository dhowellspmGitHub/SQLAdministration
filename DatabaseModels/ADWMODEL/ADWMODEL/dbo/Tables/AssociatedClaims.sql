CREATE TABLE [dbo].[AssociatedClaims] (
    [AssociatedClaimsId]        INT           NOT NULL,
    [AssociationTypeId]         INT           NOT NULL,
    [AssociationDesc]           VARCHAR (300) NULL,
    [AssociationTitleDesc]      VARCHAR (200) NULL,
    [CurrentRecordInd]          BIT           NOT NULL,
    [SourceSystemCreatedTmstmp] DATETIME2 (7) NULL,
    [SourceSystemUserCreatedId] CHAR (10)     NULL,
    [SourceSystemUpdatedTmstmp] DATETIME2 (7) NULL,
    [SourceSystemUserUpdatedId] CHAR (10)     NULL,
    [SourceSystemId]            INT           NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AssociatedClaims] PRIMARY KEY CLUSTERED ([AssociatedClaimsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_AssociatedClaims_ClaimCodeLookup_01] FOREIGN KEY ([AssociationTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

