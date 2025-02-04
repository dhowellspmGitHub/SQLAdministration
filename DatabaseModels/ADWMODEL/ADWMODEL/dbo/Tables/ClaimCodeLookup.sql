CREATE TABLE [dbo].[ClaimCodeLookup] (
    [ClaimCodeLookupId] INT           NOT NULL,
    [TypeCd]            VARCHAR (50)  NOT NULL,
    [TypeDesc]          VARCHAR (200) NULL,
    [LookupEntityNm]    VARCHAR (100) NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    [SourceSystemId]    INT           NOT NULL,
    [CurrentRecordInd]  BIT           NOT NULL,
    [RetiredInd]        CHAR (1)      NOT NULL,
    CONSTRAINT [PK_ClaimCode] PRIMARY KEY CLUSTERED ([ClaimCodeLookupId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

