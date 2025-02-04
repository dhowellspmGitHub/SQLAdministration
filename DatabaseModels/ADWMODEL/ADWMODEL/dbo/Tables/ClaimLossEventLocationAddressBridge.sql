CREATE TABLE [dbo].[ClaimLossEventLocationAddressBridge] (
    [ClaimID]                    INT           NOT NULL,
    [LossEventLocationAddressId] INT           NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimLossEventLocationAddressBridge] PRIMARY KEY NONCLUSTERED ([ClaimID] ASC, [LossEventLocationAddressId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimLossEventLocationAddBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_CLELAB_LELA_01] FOREIGN KEY ([LossEventLocationAddressId]) REFERENCES [dbo].[LossEventLocationAddress] ([LossEventLocationAddressId])
) ON [CLAIMSCD];

