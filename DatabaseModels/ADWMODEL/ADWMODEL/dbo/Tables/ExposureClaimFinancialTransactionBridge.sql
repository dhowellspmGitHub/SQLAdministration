CREATE TABLE [dbo].[ExposureClaimFinancialTransactionBridge] (
    [ExposureId]                  INT           NOT NULL,
    [ClaimFinancialTransactionId] INT           NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ExposureClaimFinanicialTransactionBridge] PRIMARY KEY NONCLUSTERED ([ExposureId] ASC, [ClaimFinancialTransactionId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureCFTBridge_CFT_01] FOREIGN KEY ([ClaimFinancialTransactionId]) REFERENCES [dbo].[ClaimFinancialTransaction] ([ClaimFinancialTransactionId]),
    CONSTRAINT [FK_ExposureCFTBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId])
) ON [CLAIMSCD];

