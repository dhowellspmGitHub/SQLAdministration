CREATE TABLE [dbo].[ClaimExposureReserveAmountsBridge] (
    [ClaimID]           INT           NOT NULL,
    [ExposureAmountsId] INT           NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimExposureReserveAmountsBridge] PRIMARY KEY CLUSTERED ([ClaimID] ASC, [ExposureAmountsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimExposureReserveAmountsBridge_Claims_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimExposureReserveAmountsBridge_ExposureReserveAmounts_01] FOREIGN KEY ([ExposureAmountsId]) REFERENCES [dbo].[ExposureReserveAmounts] ([ExposureAmountsId])
) ON [CLAIMSCD];

