CREATE TABLE [dbo].[ClaimUserRole] (
    [ClaimUserRoleId]     INT           NOT NULL,
    [ClaimUserRoleDesc]   CHAR (50)     NOT NULL,
    [ClaimUserUpdatedId]  CHAR (8)      NOT NULL,
    [ClaimUserCreateTime] DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]  CHAR (8)      NOT NULL,
    [ClaimUpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [RetiredInd]          CHAR (1)      NOT NULL,
    [SourceSystemId]      INT           NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [CurrentRecordInd]    BIT           NOT NULL,
    CONSTRAINT [PK_ClaimUserRole] PRIMARY KEY NONCLUSTERED ([ClaimUserRoleId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

