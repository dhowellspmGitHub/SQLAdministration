CREATE TABLE [dbo].[ClaimClaimReserveAmountsBridge] (
    [ClaimID]        INT           NOT NULL,
    [ClaimAmountsId] INT           NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimClaimReserveAmountsBridge] PRIMARY KEY CLUSTERED ([ClaimID] ASC, [ClaimAmountsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimClaimReserveAmountsBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimClaimReserveAmountsBridge_ClaimReserveAmounts_01] FOREIGN KEY ([ClaimAmountsId]) REFERENCES [dbo].[ClaimReserveAmounts] ([ClaimAmountsId])
) ON [CLAIMSCD];

