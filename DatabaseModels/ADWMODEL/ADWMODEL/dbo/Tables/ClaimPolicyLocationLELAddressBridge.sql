CREATE TABLE [dbo].[ClaimPolicyLocationLELAddressBridge] (
    [ClaimPolicyLocationId]      INT           NOT NULL,
    [LossEventLocationAddressId] INT           NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    CONSTRAINT [PK_ClaimPolicyLocationLELAddressBridge] PRIMARY KEY CLUSTERED ([ClaimPolicyLocationId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

