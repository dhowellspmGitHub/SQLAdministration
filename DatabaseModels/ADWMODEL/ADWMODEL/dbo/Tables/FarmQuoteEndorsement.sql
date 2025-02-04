CREATE TABLE [dbo].[FarmQuoteEndorsement] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [LivestockUnitCnt]      INT            NULL,
    [BoardedAnimalCnt]      INT            NULL,
    [RiderFeeAmt]           DECIMAL (9, 2) NULL,
    [OtherRiderInd]         CHAR (1)       NULL,
    [HorseLimitAmt]         DECIMAL (9)    NULL,
    [YearLimitAmt]          DECIMAL (9)    NULL,
    [PerOccurrenceLimitAmt] DECIMAL (9)    NULL,
    [AnnualTotalLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementLimitCd]    CHAR (3)       NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_FarmQuoteEndorsement_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteEndorsement_01]
    ON [dbo].[FarmQuoteEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

